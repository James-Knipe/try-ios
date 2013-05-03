//
//  MTViewController.m
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTViewController.h"
#import "MTBoardCell.h"
#import "MTHostGameViewController.h"
#import "MTJoinGameViewController.h"
#import "MTGameController.h"

#define kMTMatrixWidth 7
#define kMTMatrixHeight 6

@interface MTViewController ()<MTGameControllerDelegate,MTHostGameViewControllerDelegate, MTJoinGameViewControllerDelegate>

@property(assign, nonatomic) MTGameState gameState;
@property(strong, nonatomic) MTGameController *gameController;
@property(strong, nonatomic) NSArray *board;
@property(strong, nonatomic) NSMutableArray *matrix;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup View
    [self setupView];
}

- (void)setupView
{
    // Reset Game
    [self resetGame];
    // Configure Subviews
    [self.boardView setHidden:YES];
    [self.replayButton setHidden:YES];
    [self.disconnectButton setHidden:YES];
    [self.gameStateLabel setHidden:YES];
    // Add Tap Gesture Recognizer
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDiscToColumn:)];
    [self.boardView addGestureRecognizer:tgr];
}

- (void)setGameState:(MTGameState)gameState
{
    if(_gameState != gameState){
        _gameState = gameState;
        [self updateView];
    }
}

- (void)updateView {
    // Update Game State Label
    switch (self.gameState) {
        case MTGameStateMyTurn: {
            self.gameStateLabel.text = NSLocalizedString(@"It is your turn.", nil);
            break;
        }
        case MTGameStateYourTurn: {
            self.gameStateLabel.text = NSLocalizedString(@"It is your opponent's turn.", nil);
            break;
        }
        case MTGameStateIWin: {
            self.gameStateLabel.text = NSLocalizedString(@"You have won.", nil);
            break;
        }
        case MTGameStateYouWin: {
            self.gameStateLabel.text = NSLocalizedString(@"Your opponent has won.", nil);
            break;
        }
        default: {
            self.gameStateLabel.text = nil;
            break;
        }
    }
}

- (IBAction)hostGame:(id)sender
{
    MTHostGameViewController *hostGameViewController = [[MTHostGameViewController alloc] initWithNibName:@"MTHostGameViewController" bundle:[NSBundle mainBundle]];
    // Configue Host Game View Controller
    [hostGameViewController setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:hostGameViewController];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)joinGame:(id)sender
{
    MTJoinGameViewController *joinGameViewController = [[MTJoinGameViewController alloc] initWithStyle:UITableViewStylePlain];
    // Configure Join Game View Controller
    [joinGameViewController setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:joinGameViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)replay:(id)sender
{
    // Reset Game
    [self resetGame];
    // Update Game State
    self.gameState = MTGameStateMyTurn;
    // Notify Opponent of New Game
    [self.gameController startNewGame];
}

- (IBAction)disconnect:(id)sender
{
    [self endGame];
}

- (void)startGameWithSocket:(GCDAsyncSocket *)socket
{
    // Initialize Game Controller
    self.gameController = [[MTGameController alloc] initWithSocket:socket];
    self.gameController.delegate = self;
    // Hide/Show Buttons
    [self.boardView setHidden:NO];
    [self.hostButton setHidden:YES];
    [self.joinButton setHidden:YES];
    [self.disconnectButton setHidden:NO];
    [self.gameStateLabel setHidden:NO];
}

- (void)endGame
{
    // Clean Up
    [self.gameController setDelegate:nil];
    [self setGameController:nil];
    // Hide/Show Buttons
    [self.boardView setHidden:YES];
    [self.hostButton setHidden:NO];
    [self.joinButton setHidden:NO];
    [self.disconnectButton setHidden:YES];
    [self.gameStateLabel setHidden:YES];
    
    //[self resetGame];
}

- (void)resetGame
{
    // Hide Replay Button
    [self.replayButton setHidden:YES];
    // Helpers
    CGSize size = self.boardView.frame.size;
    CGFloat cellWidth = floorf(size.width / kMTMatrixWidth);
    CGFloat cellHeight = floorf(size.height / kMTMatrixHeight);
    NSMutableArray *buffer = [[NSMutableArray alloc] initWithCapacity:kMTMatrixWidth];
    for (int i = 0; i < kMTMatrixWidth; i++) {
        NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kMTMatrixHeight];
        for (int j = 0; j < kMTMatrixHeight; j++) {
            CGRect frame = CGRectMake(i * cellWidth, (size.height - ((j + 1) * cellHeight)), cellWidth, cellHeight);
            MTBoardCell *cell = [[MTBoardCell alloc] initWithFrame:frame];
            [cell setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            [self.boardView addSubview:cell];
            [column addObject:cell];
        }
        [buffer addObject:column];
    }
    // Initialize Board
    self.board = [[NSArray alloc] initWithArray:buffer];
    // Initialize Matrix
    self.matrix = [[NSMutableArray alloc] initWithCapacity:kMTMatrixWidth];
    for (int i = 0; i < kMTMatrixWidth; i++) {
        NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kMTMatrixHeight];
        [self.matrix addObject:column];
    }
}

- (void)addDiscToColumn:(UITapGestureRecognizer *)sender
{
    if(self.gameState >= MTGameStateIWin){
        // Notify Players
        [self showWinner];
    } else if(self.gameState != MTGameStateMyTurn){
        NSString *message = NSLocalizedString(@"It's not your turn.", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    } else {
        NSInteger column = [self columnForPoint:[sender locationInView:sender.view]];
        [self addDiscToColumn:column withType:MTBoardCellTypeMine];
        // Update Game State
        [self setGameState:MTGameStateYourTurn];
        // Send Packet
        [self.gameController addDiscToColumn:column];
        // Notify Plays if Someone Has Won the Game
        if([self hasPlayerOfTypeWon:MTPlayerTypeMe]){
            [self showWinner];
        }
    }
}

- (NSInteger)columnForPoint:(CGPoint)point
{
    return floorf(point.x / floorf(self.boardView.frame.size.width / kMTMatrixWidth));
}

- (void)addDiscToColumn:(NSInteger)column withType:(MTBoardCellType)cellType
{
    // Update Matrix
    NSMutableArray *columnArray = [self.matrix objectAtIndex:column];
    [columnArray addObject:@(cellType)];
    // Update Cells
    MTBoardCell *cell = [[self.board objectAtIndex:column] objectAtIndex:([columnArray count]-1)];
    [cell setCellType:cellType];
}

- (BOOL)hasPlayerOfTypeWon:(MTPlayerType)playerType {
    BOOL _hasWon = NO;
    NSInteger _counter = 0;
    MTBoardCellType targetType = playerType == MTPlayerTypeMe ? MTBoardCellTypeMine : MTBoardCellTypeYours;
    // Check Vertical Matches
    for (NSArray *line in self.board) {
        _counter = 0;
        for (MTBoardCell *cell in line) {
            _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
            _hasWon = (_counter > 3) ? YES : _hasWon;
            if (_hasWon) break;
        }
        if (_hasWon) break;
    }
    if (!_hasWon) {
        // Check Horizontal Matches
        for (int i = 0; i < kMTMatrixHeight; i++) {
            _counter = 0;
            for (int j = 0; j < kMTMatrixWidth; j++) {
                MTBoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:i];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
                if (_hasWon) break;
            }
            if (_hasWon) break;
        }
    }
    if (!_hasWon) {
        // Check Diagonal Matches - First Pass
        for (int i = 0; i < kMTMatrixWidth; i++) {
            _counter = 0;
            // Forward
            for (int j = i, row = 0; j < kMTMatrixWidth && row < kMTMatrixHeight; j++, row++) {
                MTBoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
                if (_hasWon) break;
            }
            if (_hasWon) break;
            _counter = 0;
            // Backward
            for (int j = i, row = 0; j >= 0 && row < kMTMatrixHeight; j--, row++) {
                MTBoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
                if (_hasWon) break;
            }
            if (_hasWon) break;
        }
    }
    if (!_hasWon) {
        // Check Diagonal Matches - Second Pass
        for (int i = 0; i < kMTMatrixWidth; i++) {
            _counter = 0;
            // Forward
            for (int j = i, row = (kMTMatrixHeight - 1); j < kMTMatrixWidth && row >= 0; j++, row--) {
                MTBoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
                if (_hasWon) break;
            }
            if (_hasWon) break;
            _counter = 0;
            // Backward
            for (int j = i, row = (kMTMatrixHeight - 1); j >= 0 && row >= 0; j--, row--) {
                MTBoardCell *cell = [(NSArray *)[self.board objectAtIndex:j] objectAtIndex:row];
                _counter = (cell.cellType == targetType) ? _counter + 1 : 0;
                _hasWon = (_counter > 3) ? YES : _hasWon;
                if (_hasWon) break;
            }
            if (_hasWon) break;
        }
    }
    // Update Game State
    if (_hasWon) {
        self.gameState = (playerType == MTPlayerTypeMe) ? MTGameStateIWin : MTGameStateYouWin;
    }
    return _hasWon;
}

- (void)showWinner {
    if (self.gameState < MTGameStateIWin)
        return;
    // Show Replay Button
    [self.replayButton setHidden:NO];
    NSString *message = nil;
    if (self.gameState == MTGameStateIWin) {
        message = NSLocalizedString(@"You have won the game.", nil);
    } else if (self.gameState == MTGameStateYouWin) {
        message = NSLocalizedString(@"Your opponent has won the game.", nil);
    }
    // Show Alert View
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We Have a Winner" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Host Game View Controller Methods
- (void)controller:(MTHostGameViewController *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Update Game State
    [self setGameState:MTGameStateMyTurn];
    // Start Game with Socket
    [self startGameWithSocket:socket];
    // Test Connection
    //[self.gameController testConnection];
}

- (void)controllerDidCancelHosting:(MTHostGameViewController *)controller
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark Join Game View Controller Methods
- (void)controller:(MTJoinGameViewController *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Update Game State
    [self setGameState:MTGameStateYourTurn];
    // Start Game with Socket
    [self startGameWithSocket:socket];
}

- (void)controllerDidCancelJoining:(MTJoinGameViewController *)controller
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark MTGameControllerDelegate
- (void)controllerDidDisconnect:(MTGameController *)controller
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self endGame];
}

- (void)controller:(MTGameController *)controller didAddDiscToColumn:(NSInteger)column {
    // Update Game
    [self addDiscToColumn:column withType:MTBoardCellTypeYours];
    if([self hasPlayerOfTypeWon:MTPlayerTypeYou]){
        [self showWinner];
    } else {
        // Update State
        [self setGameState:MTGameStateMyTurn];
    }
}

- (void)controllerDidStartNewGame:(MTGameController *)controller
{
    // Reset Game
    [self resetGame];
    // Update Game State
    self.gameState = MTGameStateYourTurn;
}

@end

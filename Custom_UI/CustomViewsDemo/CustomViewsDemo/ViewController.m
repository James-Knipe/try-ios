//
//  ViewController.m
//  CustomViewsDemo
//
//  Created by Kevin on 4/29/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL isEditingItem;
}

@property(nonatomic, strong) NSMutableArray *sampleDataArray;
@property(nonatomic, strong) CustomTextInputViewController *textInput;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    _sampleDataArray = [NSMutableArray array];
    
    // Initialize the custom text input object.
    _textInput = [[CustomTextInputViewController alloc] init];
    [_textInput setDelegate:self];
    
    // Set the initial value of the isEditingItem flag.
    isEditingItem = NO;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sampleDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Georgia" size:15.0]];
    }
    [[cell textLabel] setText:[_sampleDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_textInput showCustomTextInputViewInView:self.view
                                     withText:[_sampleDataArray objectAtIndex:[indexPath row]]
                                 andWithTitle:@"Edit item"];
    // Set the isEditingItem flag value to YES, indicating that
    // we are editing an item.
    isEditingItem = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItem:(id)sender
{
    [_textInput showCustomTextInputViewInView:self.view withText:@"" andWithTitle:@"Add new item"];
}

-(void)shouldAcceptTextChanges{
    // If the isEditingItem flag is set to NO, then a new item has been
    // added to the list. Otherwise an existing item has been edited.
    if (!isEditingItem) {
        // Add the new item to the sampleDataArray.
        [_sampleDataArray addObject:[_textInput getText]];
    }
    else{
        // Replace the selected item into the array with the updated value.
        NSUInteger index = [[_table indexPathForSelectedRow] row];
        [_sampleDataArray replaceObjectAtIndex:index withObject:[_textInput getText]];
        // Set the isEditingItem flag to NO.
        isEditingItem = NO;
    }
    // Reload the table using animation.
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    // Close the text input.
    [_textInput closeTextInputView];
}

-(void)shouldDismissTextChanges{
    [_textInput closeTextInputView];
}

@end

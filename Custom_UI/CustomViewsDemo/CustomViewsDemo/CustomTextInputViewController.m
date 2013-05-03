//
//  CustomTextInputViewController.m
//  CustomViewsDemo
//
//  Created by Kevin on 4/29/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "CustomTextInputViewController.h"

@interface CustomTextInputViewController ()
{
    CGFloat statusBarOffset;
}

- (void)keyboardWillShowWithNotification:(NSNotification *)notification;

@end

@implementation CustomTextInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the textfield delegate.
    [_txtText setDelegate:self];
    // Set the input accessory view of the textfield.
    [_txtText setInputAccessoryView:_toolbarIAV];
    
    // Set the background color of the view to a semi-transparent gray.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:0.75]];
    
    // Add self as observer to the NSNotificationCenter so we know when the keyboard is about to be shown up.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptTextChanges:(id)sender
{
    [self.delegate shouldAcceptTextChanges];
}

- (IBAction)cancelTextChanges:(id)sender
{
    [self.delegate shouldDismissTextChanges];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // The tap on the Done button of the keyboard equals to the Okay button.
    [self.delegate shouldAcceptTextChanges];
    return YES;
}

-(void)showCustomTextInputViewInView:(UIView *)targetView
                            withText:(NSString *)text
                        andWithTitle:(NSString *)title
{
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        if (statusBarSize.width < statusBarSize.height) {
            // If the width is smaller than the height then this is the value we need.
            statusBarOffset = statusBarSize.width;
        }
        else{
            // Otherwise the height is the desired value we want to keep.
            statusBarOffset = statusBarSize.height;
        }
    }
    else{
        // Otherwise set it to 0.0.
        statusBarOffset = 0.0;
    }
    // Before showing the self.view on-screen, we need to calculate the following
    // values, depending always on the orientation.
    CGFloat x, width, height;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        // Landscape orientation.
        // Set the x point for the view. If we don't substract the statusBarOffset value then a
        // padding is going to exist at the left of the view when it will appear.
        x = targetView.frame.origin.x - statusBarOffset;
        // In landscape orientation, the width of the view equals to the height of the target view.
        width = targetView.frame.size.height;
        // The same with the height.
        height = targetView.frame.size.width;
    }
    else{
        // In portrait orientation everything is normal.
        x = targetView.frame.origin.x;
        width = targetView.frame.size.width;
        height = targetView.frame.size.height;
    }
    // Initially set the self.view off screen. That's why the y point equals to -height.
    [self.view setFrame:CGRectMake(x,
                                   -height,
                                   width,
                                   height)];
    // Add the view to the target view.
    [targetView addSubview:self.view];
    // Begin animating the appearance of the view.
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    // We simply want the y point of the origin to become 0.0.
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                   0.0,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height)];
    [UIView commitAnimations];
    // Set the textfield as the first responder to make the keyboard appear.
    [_txtText becomeFirstResponder];
    // Set the text to edit (if exists) to the textfield.
    [_txtText setText:text];
    // Set the label's text (the title above the textfield).
    [_lblTitle setText:title];
}

-(void)closeTextInputView{
    // Resign the textfield from first responder to make the keyboard go away.
    [_txtText resignFirstResponder];
    // Animate the view closing. It's just the opposite from the showing animation.
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                   -self.view.frame.size.height,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height)];
    [UIView commitAnimations];
    // Also remove the view from the superview after a while (we must let the animation finish first).
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.25];
}

-(NSString *)getText
{
    return [_txtText text];
}

- (void)keyboardWillShowWithNotification:(NSNotification *)notification
{
    // Get the userInfo dictionary from the notification object.
    NSDictionary *info = [notification userInfo];
    // Get the keyboard origin.
    CGPoint keyboardOrigin = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    CGFloat keyboardOriginY;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        // In landscape orientation the x point represents the vertical axis.
        keyboardOriginY = keyboardOrigin.x;
    }
    else{
        keyboardOriginY = keyboardOrigin.y;
    }
    // Set the appropriate frame for the textfield. That is just right above the input accessory view.
    [_txtText setFrame:CGRectMake(_txtText.frame.origin.x,
                                  keyboardOriginY - _txtText.frame.size.height - statusBarOffset,
                                  _txtText.frame.size.width,
                                  _txtText.frame.size.height)];
    // Set the label's frame in turn.
    [_lblTitle setFrame:CGRectMake(0.0,
                                   _txtText.frame.origin.y - _lblTitle.frame.size.height,
                                   _lblTitle.frame.size.width,
                                   _lblTitle.frame.size.height)];
}

@end

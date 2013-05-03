//
//  CustomTextInputViewController.h
//  CustomViewsDemo
//
//  Created by Kevin on 4/29/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextInputViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtText;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarIAV;
@property (nonatomic, strong) id delegate;

- (IBAction)acceptTextChanges:(id)sender;
- (IBAction)cancelTextChanges:(id)sender;

-(void)showCustomTextInputViewInView:(UIView *)targetView
                            withText:(NSString *)text
                        andWithTitle:(NSString *)title;
-(void)closeTextInputView;
-(NSString *)getText;

@end

@protocol CustomTextInputViewControllerDelegate
-(void)shouldAcceptTextChanges;
-(void)shouldDismissTextChanges;
@end

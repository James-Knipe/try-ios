//
//  RoleDetailTVC.m
//  Staff Manager
//
//  Created by Tim Roadley on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoleDetailTVC.h"

@implementation RoleDetailTVC
@synthesize delegate;
@synthesize roleNameTextField;
@synthesize role = _role;

- (void)viewDidLoad 
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Role");
    self.roleNameTextField.text = self.role.name;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setRoleNameTextField:nil];
    [super viewDidUnload];
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (IBAction)save:(id)sender
{
    NSLog(@"Telling the AddRoleTVC Delegate that Save was tapped on the AddRoleTVC");
    [self.role setName:roleNameTextField.text];
    [self.role.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheRoleDetailTVCWasTapped:self];
}
@end



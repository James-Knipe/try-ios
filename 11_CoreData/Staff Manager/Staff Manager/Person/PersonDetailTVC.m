//
//  PersonDetailTVC.m
//  Staff Manager
//
//  Created by Tim Roadley on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonDetailTVC.h"

@implementation PersonDetailTVC
@synthesize delegate;
@synthesize person = _person;
@synthesize selectedRole;
@synthesize personFirstnameTextField = _personFirstnameTextField;
@synthesize personSurnameTextField = _personSurnameTextField;
@synthesize personRoleTableViewCell = _personRoleTableViewCell;

- (void)viewDidLoad 
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Person");
    //self.personNameTextField.text = self.person.name;
    self.personFirstnameTextField.text = self.person.firstname;
    self.personSurnameTextField.text = self.person.surname;
    self.personRoleTableViewCell.textLabel.text = self.person.inRole.name;
    self.selectedRole = self.person.inRole; // ensure null role doesn't get saved.

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    //[self setPersonNameTextField:nil];
    [self setPersonFirstnameTextField:nil];
    [self setPersonSurnameTextField:nil];
    [self setPersonRoleTableViewCell:nil];
    [super viewDidUnload];
}

- (IBAction)save:(id)sender
{
    NSLog(@"Telling the PersonDetailTVC Delegate that Save was tapped on the PersonDetailTVC");
    
    self.person.firstname = self.personFirstnameTextField.text; // Set Firstname
    self.person.surname = self.personSurnameTextField.text; // Set Surname
    [self.person setInRole:self.selectedRole]; // Set Relationship!!!
    [self.person.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnThePersonDetailTVCWasTapped:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  // !
{
    if ([segue.identifier isEqualToString:@"Person Role Segue"])
	{
        NSLog(@"Setting PersonDetailTVC as a delegate of PersonRoleTVC");
        PersonRoleTVC *personRoleTVC = segue.destinationViewController;
        personRoleTVC.delegate = self;
        personRoleTVC.selectedPerson = self.person;
	}
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (void)roleWasSelectedOnPersonRoleTVC:(PersonRoleTVC *)controller 
{
    self.personRoleTableViewCell.textLabel.text = controller.selectedRole.name;
    self.selectedRole = controller.selectedRole;
    NSLog(@"PersonDetailTVC reports that the %@ role was selected on the PersonRoleTVC", controller.selectedRole.name);
    [controller.navigationController popViewControllerAnimated:YES];
}


@end



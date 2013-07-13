//
//  PersonDetailTVC.h
//  Staff Manager
//
//  Created by Tim Roadley on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Role.h"
#import "PersonRoleTVC.h"

@class PersonDetailTVC;
@protocol PersonDetailTVCDelegate <NSObject>
- (void)theSaveButtonOnThePersonDetailTVCWasTapped:(PersonDetailTVC *)controller;
@end

@interface PersonDetailTVC : UITableViewController <PersonRoleTVCDelegate>
@property (nonatomic, weak) id <PersonDetailTVCDelegate> delegate;
@property (strong, nonatomic) Person *person;
@property (strong, nonatomic) Role *selectedRole;
@property (strong, nonatomic) IBOutlet UITextField *personFirstnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *personSurnameTextField;
@property (strong, nonatomic) IBOutlet UITableViewCell *personRoleTableViewCell;

- (IBAction)save:(id)sender;

@end





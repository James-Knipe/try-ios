//
//  RolesTVC.m
//  Staff Manager
//
//  Created by Tim Roadley on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RolesTVC.h"
#import "Role.h"

@implementation RolesTVC
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedRole;
@synthesize searchResults;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Role"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (void)viewDidLoad 
{
    self.searchResults = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]]; 
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
	self.searchResults = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Roles Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Role *role = nil;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        NSLog(@"Configuring cell to show search results");
        role = [self.searchResults objectAtIndex:indexPath.row];
    }
	else
	{
        NSLog(@"Configuring cell to show normal data");
        role = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.textLabel.text = role.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchResults count];
    }
	else
	{
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Role *roleToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", roleToDelete.name);
        [self.managedObjectContext deleteObject:roleToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Role Segue"])
	{
        NSLog(@"Setting RolesTVC as a delegate of RoleDetailTVC");
        RoleDetailTVC *roleDetailTVC = segue.destinationViewController;
        roleDetailTVC.delegate = self;
        
        NSLog(@"Creating a new role and passing it to RoleDetailTVC");
        Role *newRole = [NSEntityDescription insertNewObjectForEntityForName:@"Role"
                                                      inManagedObjectContext:self.managedObjectContext];
        
        roleDetailTVC.role = newRole;
	}
    else if ([segue.identifier isEqualToString:@"Role Detail Segue"])
    {
        NSLog(@"Setting RolesTVC as a delegate of RoleDetailTVC");
        RoleDetailTVC *roleDetailTVC = segue.destinationViewController;
        roleDetailTVC.delegate = self;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedRole = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected role (%@) to RoleDetailTVC", self.selectedRole.name);
        roleDetailTVC.role = self.selectedRole;
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)theSaveButtonOnTheRoleDetailTVCWasTapped:(RoleDetailTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];    
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	NSLog(@"Previous Search Results were removed.");
	[self.searchResults removeAllObjects]; 
    
	for (Role *role in [self.fetchedResultsController fetchedObjects])
	{
		if ([scope isEqualToString:@"All"] || [role.name isEqualToString:scope])
		{
			NSComparisonResult result = [role.name compare:searchText 
                                                   options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
                                                     range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
                NSLog(@"Adding role.name '%@' to searchResults as it begins with search text '%@'", role.name, searchText);
				[self.searchResults addObject:role];
            }
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:@"All"];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    return YES;
}

@end

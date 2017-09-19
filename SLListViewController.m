//
//  SLListViewController.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLListViewController.h"
#import "SLItem.h"
#import "SLEditItemViewController.h"

@interface SLListViewController ()

@property NSMutableArray *items;

@end

@implementation SLListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // Set Title & Image
        self.title =@"Items";
        UIImage* anImage = [UIImage imageNamed:@"itemsTab.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Items" image:anImage tag:0];
        self.tabBarItem = theItem;
        
        // Load Items
        [self loadItems];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Add Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
    
    //swipe left to shopping list
    UISwipeGestureRecognizer *swipeRecognizerLeft = [ [ UISwipeGestureRecognizer alloc ] initWithTarget:self action:@selector( slideLeft ) ];
    [ swipeRecognizerLeft setDirection:( UISwipeGestureRecognizerDirectionLeft ) ];
    [ self.view addGestureRecognizer:swipeRecognizerLeft ];
    
    NSLog(@"Items > %@", self.items);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    SLItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    
    // Show/Hide Checkmark
    if ([item inShoppingList]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if ([indexPath row] == 1) {
     return NO;
     }
     */
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete Item from Items
        [self.items removeObjectAtIndex:[indexPath row]];
        
        // Update Table View
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        // Save Changes to Disk
        [self saveItems];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Item
    SLItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Update Item
    [item setInShoppingList:![item inShoppingList]];
    
    // Update Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if ([item inShoppingList]) {
       // [cell.imageView setImage:[UIImage imageNamed:@"checkmark"]]; <-- picture in tutorial
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
       // [cell.detailTextLabel setTag:[item price]];
    } else {
       // [cell.imageView setImage:nil];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    // Save Items
    [self saveItems];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    SLItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Initialize Edit Item View Controller
    SLEditItemViewController *editItemViewController = [[SLEditItemViewController alloc] initWithItem:item andDelegate:self];
    
    // Push View Controller onto Navigation Stack
    [self.navigationController pushViewController:editItemViewController animated:YES];
}


- (void)controller:(SLAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(float)price {
    // Create Item
    SLItem *item = [SLItem createItemWithName:name andPrice:price];
    
    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Save Items
    [self saveItems];
}


- (void)controller:(SLEditItemViewController *)controller didUpdateItem:(SLItem *)item {
    // Fetch Item
    for (int i = 0; i < [self.items count]; i++) {
        SLItem *anItem = [self.items objectAtIndex:i];
        
        if ([[anItem uuid] isEqualToString:[item uuid]]) {
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    // Save Items
    [self saveItems];
}


- (void)addItem:(id)sender {
    // Initialize Add Item View Controller
    SLAddItemViewController *addItemViewController = [[SLAddItemViewController alloc] initWithNibName:@"SLAddItemViewController" bundle:nil];
    
    // Set Delegate
    [addItemViewController setDelegate:self];
    
    // Present View Controller
    [self presentViewController:addItemViewController animated:YES completion:nil];
}

- (void)editItems:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}


- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (void)saveItems {
    NSString *filePath = [self pathForItems];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SLShoppingListDidChangeNotification" object:self];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

- (void) slideLeft //swipe to controller to the left to shopping list
{
    //animation transition
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
   // [self presentModalViewController:viewController animated:yes];
    
    self.tabBarController.selectedIndex++;
}

@end

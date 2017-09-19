//
//  SLShoppingListViewController.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLShoppingListViewController.h"
#import "SLItem.h"

@interface SLShoppingListViewController ()

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *shoppingList;

@end

@implementation SLShoppingListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // Set Title & Image
        self.title =@"Shopping List";
        UIImage* anImage = [UIImage imageNamed:@"shoplistTab.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Shopping List" image:anImage tag:0];
        self.tabBarItem = theItem;
        
        // Load Items
        [self loadItems];
        
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingList:) name:@"SLShoppingListDidChangeNotification" object:nil];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //swipe right to items list
    UISwipeGestureRecognizer *swipeRecognizerRight = [ [ UISwipeGestureRecognizer alloc ] initWithTarget:self action:@selector( slideRight ) ];
    [ swipeRecognizerRight setDirection:( UISwipeGestureRecognizerDirectionRight ) ];
    [ self.view addGestureRecognizer:swipeRecognizerRight ];
    
    //swipe left to map
    UISwipeGestureRecognizer *swipeRecognizerLeft = [ [ UISwipeGestureRecognizer alloc ] initWithTarget:self action:@selector( slideLeft ) ];
    [ swipeRecognizerLeft setDirection:( UISwipeGestureRecognizerDirectionLeft ) ];
    [ self.view addGestureRecognizer:swipeRecognizerLeft ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        
        // Build Shopping List
        [self buildShoppingList];
    }
}

- (void)setShoppingList:(NSArray *)shoppingList {
    if (_shoppingList != shoppingList) {
        _shoppingList = shoppingList;
        
        // Reload Table View
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shoppingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Fetch Item
    SLItem *item = [self.shoppingList objectAtIndex:[indexPath row]];
    
    NSString *priceString;
    
    if ([item price] != 0) {
        priceString = [[NSString alloc] initWithFormat:@"$%.2f", [item price]];
    }
    else {
        priceString = @"--";
    }
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell.detailTextLabel setText: priceString];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Item
    SLItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Update Item
    //[item setInShoppingList:![item inShoppingList]];
    
    // Update Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    // Set checkmarks
    if ([item inShoppingList]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [item setInShoppingList:![item inShoppingList]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [item setInShoppingList:![item inShoppingList]];
    }
}


- (void)updateShoppingList:(NSNotification *)notification {
    // Load Items
    [self loadItems];
}

- (void)loadItems {
    NSString *filePath = [self pathForItems];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // self.items = [NSMutableArray arrayWithContentsOfFile:filePath];
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (void)buildShoppingList {
    NSMutableArray *buffer = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.items count]; i++) {
        SLItem *item = [self.items objectAtIndex:i];
        
        if ([item inShoppingList]) {
            // Add Item to Buffer
            [buffer addObject:item];
        }
    }
    
    // Set Shopping List
    self.shoppingList = [NSArray arrayWithArray:buffer];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

- (void) slideRight //swipe to controller to the right to items
{
    //animation transition
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    //swipe to previous controller
    self.tabBarController.selectedIndex--;
}

- (void) slideLeft //swipe to controller to the left to map
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

//
//  SLAppDelegate.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLAppDelegate.h"
#import "SLItem.h"
#import "SLListViewController.h"
#import "SLShoppingListViewController.h"
#import "SLMapViewController.h"

@implementation SLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Seed Items
    [self seedItems];
    
    // Initialize List View Controller
    SLListViewController *listViewController = [[SLListViewController alloc] init];
    
    // Initialize Navigation Controller
    UINavigationController *listNavigationController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    // Initialize Shopping List View Controller
    SLShoppingListViewController *shoppingListViewController = [[SLShoppingListViewController alloc] init];
    
    // Initialize Navigation Controller
    UINavigationController *shoppingListNavigationController = [[UINavigationController alloc] initWithRootViewController:shoppingListViewController];
    
    // Initialize Shopping List View Controller
    SLMapViewController *mapViewController = [[SLMapViewController alloc] init];
    
    // Initialize Navigation Controller
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    // Initialize Tab Bar Controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // Configure Tab Bar Controller
    [tabBarController setViewControllers:@[listNavigationController, shoppingListNavigationController, mapNavigationController]];
    
    // Initialize Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Configure Window
    [self.window setRootViewController:tabBarController];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)seedItems {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (![ud boolForKey:@"SLUserDefaultsSeedItems"]) {
        // Load Seed Items
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"plist"];
        NSArray *seedItems = [NSArray arrayWithContentsOfFile:filePath];
        
        // Items
        NSMutableArray *items = [NSMutableArray array];
        
        // Create List of Items
        for (int i = 0; i < [seedItems count]; i++) {
            NSDictionary *seedItem = [seedItems objectAtIndex:i];
            
            // Create Item
            SLItem *item = [SLItem createItemWithName:[seedItem objectForKey:@"name"] andPrice:[[seedItem objectForKey:@"price"] floatValue]];
            
            // Add Item to Items
            [items addObject:item];
        }
        
        // Items Path
        NSString *itemsPath = [[self documentsDirectory] stringByAppendingPathComponent:@"items.plist"];
        
        // Write to File
        if ([NSKeyedArchiver archiveRootObject:items toFile:itemsPath]) {
            [ud setBool:YES forKey:@"SLUserDefaultsSeedItems"];
        }
    }
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

@end

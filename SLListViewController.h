//
//  SLListViewController.h
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAddItemViewController.h"
#import "SLEditItemViewController.h"

@interface SLListViewController : UITableViewController <SLAddItemViewControllerDelegate, SLEditItemViewControllerDelegate>

@end

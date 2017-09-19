//
//  SLEditItemViewController.h
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLItem;
@protocol SLEditItemViewControllerDelegate;

@interface SLEditItemViewController : UIViewController

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;


- (id)initWithItem:(SLItem *)item andDelegate:(id<SLEditItemViewControllerDelegate>)delegate;

@end

@protocol SLEditItemViewControllerDelegate <NSObject>
- (void)controller:(SLEditItemViewController *)controller didUpdateItem:(SLItem *)item;
@end

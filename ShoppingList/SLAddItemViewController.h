//
//  SLAddItemViewController.h
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLAddItemViewControllerDelegate;

@interface SLAddItemViewController : UIViewController

@property (weak) id<SLAddItemViewControllerDelegate> delegate;

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *priceTextField;

@end


@protocol SLAddItemViewControllerDelegate <NSObject>
- (void)controller:(SLAddItemViewController *)controller didSaveItemWithName:(NSString *)name andPrice:(float)price;
@end

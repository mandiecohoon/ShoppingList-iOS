//
//  SLList.h
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLItem : NSObject <NSCoding>

@property NSString *uuid;
@property NSString *name;
@property float price;
@property BOOL inShoppingList;

+ (SLItem *)createItemWithName:(NSString *)name andPrice:(float)price;

@end


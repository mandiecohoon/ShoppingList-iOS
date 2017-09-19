//
//  SLList.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLItem.h"

@implementation SLItem

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        [self setUuid:[decoder decodeObjectForKey:@"uuid"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setPrice:[decoder decodeFloatForKey:@"price"]];
        [self setInShoppingList:[decoder decodeBoolForKey:@"inShoppingList"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeFloat:self.price forKey:@"price"];
    [coder encodeBool:self.inShoppingList forKey:@"inShoppingList"];
}

+ (SLItem *)createItemWithName:(NSString *)name andPrice:(float)price {
    // Initialize Item
    SLItem *item = [[SLItem alloc] init];
    
    // Configure Item
    [item setName:name];
    [item setPrice:price];
    [item setInShoppingList:NO];
    [item setUuid:[[NSUUID UUID] UUIDString]];
    
    return item;
}

@end
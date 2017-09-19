//
//  SLEditItemViewController.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-03-22.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLEditItemViewController.h"
#import "SLItem.h"

@interface SLEditItemViewController ()

@property SLItem *item;
@property (weak) id<SLEditItemViewControllerDelegate> delegate;

@end

@implementation SLEditItemViewController


- (id)initWithItem:(SLItem *)item andDelegate:(id<SLEditItemViewControllerDelegate>)delegate {
    self = [super initWithNibName:@"SLEditItemViewController" bundle:nil];
    
    if (self) {
        // Set Item
        self.item = item;
        
        // Set Delegate
        self.delegate = delegate;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Save Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    // Populate Text Fields
    if (self.item) {
        [self.nameTextField setText:[self.item name]];
        [self.priceTextField setText:[NSString stringWithFormat:@"%f", [self.item price]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)save:(id)sender {
    NSString *name = [self.nameTextField text];
    float price = [[self.priceTextField text] floatValue];
    
    // Update Item
    [self.item setName:name];
    [self.item setPrice:price];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateItem:self.item];
    
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end

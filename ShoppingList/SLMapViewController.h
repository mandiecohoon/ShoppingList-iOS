//
//  SLMapViewController.h
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-04-07.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SLMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (readonly, nonatomic) CLLocation *location;

@end

//
//  SLMapViewController.m
//  ShoppingList
//
//  Created by Amanda Cohoon on 2014-04-07.
//  Copyright (c) 2014 Amanda Cohoon. All rights reserved.
//

#import "SLMapViewController.h"

@interface SLMapViewController ()

@end

@implementation SLMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set Title & Image
        self.title =@"Stores Near You";
        UIImage* anImage = [UIImage imageNamed:@"mapTab.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Near You" image:anImage tag:0];
        self.tabBarItem = theItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [_mapView removeAnnotations:[_mapView annotations]];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.mapView.showsUserLocation = YES;
    
    double miles = 12.0;
    
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/69.0;
   
    MKCoordinateRegion region;
    region.span = span;
    region.center = self.mapView.userLocation.coordinate;
    
    [self.mapView setRegion:region animated:YES];
    
    [self performSearch];
    
}

- (void) performSearch {
    
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Grocery";
    request.region = _mapView.region;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation =
                [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [_mapView addAnnotation:annotation];
            }
    }];
}

@end

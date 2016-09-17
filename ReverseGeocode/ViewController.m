//
//  ViewController.m
//  ReverseGeocode
//
//  Created by Love on 9/17/16.
//  Copyright © 2016 Love. All rights reserved.
//

@import MapKit;
@import CoreLocation;


#import "ViewController.h"

@interface ViewController ()

//by this property we ask for geocoding
@property(strong,nonatomic) CLGeocoder *geocoder;

//mapview Property to get the lat long points
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//geocodeLabel to update with address
@property (weak, nonatomic) IBOutlet UILabel *geocodeLabel;

//image property to reach the center and map it on the mapView for lan and long
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize the geocoder
    self.geocoder = [[CLGeocoder alloc] init];
    
    
    
    self.geocodeLabel.text = nil;
    
    //half transparency
    self.geocodeLabel.alpha = 0.5;
    
}

//when the reverseGeocodeButton is tapped
- (IBAction)reverseGeocodeTapped:(id)sender {
    
    //create the 2D coordinate which will hold the lan and long
    CLLocationCoordinate2D coord = [self locationAtCenterOfMapView];
    
    //create CLLocation  from above recieved coordinates
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude ];
    
    //call the process to reverse the lan and long in previously created loc
    [self startReverseGeocodeLocation: loc];
    
    
    
}


#pragma  mark -Private

//Identify the lan and long on the center of the view
-(CLLocationCoordinate2D ) locationAtCenterOfMapView{
    
    
    //get the point at the center of the pin image view
    CGPoint centerOfPin = CGPointMake(CGRectGetMaxX(self.pinIcon.bounds),CGRectGetMidY(self.pinIcon.bounds));
    
    
    //convert the points from pin image view into lan and long at the mapView
    return [self.mapView convertPoint:centerOfPin toCoordinateFromView:self.pinIcon];
}


//to reverse the lan and long into the Address or CLLocation to CLPlacemark
-(void)startReverseGeocodeLocation:(CLLocation *)location{
    
    //ask geocoder to reverse the location stored in location
    [self.geocoder reverseGeocodeLocation:location completionHandler:
      ^(NSArray * placemarks, NSError *error){
        //selector which will be invoked after the completion of the request
          
          //handle the case of the error with UIAlertController
        if(error){
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"There Was a Problem." message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:ac animated:YES completion:nil];
            
            return;
        }
          
          //Grab some interesting bits of CLPlacemark and show it, But no dupes.
          
          //create a set to store the values from recieved CLPlacemark instance
          
          NSMutableSet *mappedPlacedDescs =[NSMutableSet new];
          
          //iterate through the recieved placemarks Array
          for(CLPlacemark *p in placemarks){
              if(p.name!=nil){
                  
                  //add to the set
                  [mappedPlacedDescs addObject:p.name];
              }
              if(p.administrativeArea != nil){
                  
                  [mappedPlacedDescs addObject:p.administrativeArea];
              }
              
              if(p.country != nil){
                  
                  [mappedPlacedDescs addObject:p.country];
              }
              
              [mappedPlacedDescs addObjectsFromArray:p.areasOfInterest];
          }
        
          
          //assign recieved data to the geocodeLable with all objects joined by new line character
          self.geocodeLabel.text = [[mappedPlacedDescs allObjects] componentsJoinedByString:@"\n"];
          
          self.geocodeLabel.alpha = 1.0;
          
      }];
}



@end

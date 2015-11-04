//
//  NearByViewController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/20.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    
}

@end

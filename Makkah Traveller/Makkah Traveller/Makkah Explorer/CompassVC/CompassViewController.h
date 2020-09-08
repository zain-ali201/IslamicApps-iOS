//
//  CompassViewController.h
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 15/10/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GeoPointCompass.h"

@interface CompassViewController : UIViewController<CLLocationManagerDelegate,GADInterstitialDelegate>
{
    AppDelegate *appDelegate;
    
    GeoPointCompass *geoPointCompass;
    GeoPointCompass *geoPointCompass1;
    
    BOOL isMenuShow;
    IBOutlet UIView* mainview;
}
@property (strong, nonatomic) IBOutlet UIImageView *needle;

@property (strong, nonatomic) IBOutlet UIImageView *compass;

@property(strong,nonatomic) CLLocationManager *locationManager;

@property (nonatomic, retain) UIImageView* arrowImageView;

@property (nonatomic) CLLocationDegrees latitudeOfTargetedPoint;

@property (nonatomic) CLLocationDegrees longitudeOfTargetedPoint;
@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

//
//  CompassViewController.m
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 15/10/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import "CompassViewController.h"
#import "SettingsVC.h"
#import "HajjStepsVC.h"
#import "UmraStepsVC.h"

@implementation CompassViewController
@synthesize needle,compass,locationManager;


- (void)viewDidLoad{
            [super viewDidLoad];
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // Create the image for the compass
   // UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
  //  arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
   // [self.view addSubview:arrowImageView];
    
    geoPointCompass = [[GeoPointCompass alloc] init];
      geoPointCompass1 = [[GeoPointCompass alloc] init];
    
    // Add the image to be used as the compass on the GUI
     [geoPointCompass1 setCompass:compass];
     [geoPointCompass setArrowImageView:needle];
    
    // Set the coordinates of the location to be used for calculating the angle
    geoPointCompass.latitudeOfTargetedPoint = 21.4220;
    geoPointCompass.longitudeOfTargetedPoint = 39.8260;
    geoPointCompass1.latitudeOfTargetedPoint = 21.4220;
    geoPointCompass1.longitudeOfTargetedPoint = 39.8260;
    
    [self.bannerView setAdUnitID:adUnitID];
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:[GADRequest request]];
    
    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:interstitialUnitID];
    self.interstitial.delegate = self;
    GADRequest *request1 = [GADRequest request];
    [self.interstitial loadRequest:request1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

-(IBAction)backBtnAction:(id)sender
{
    [appDelegate.navController popViewControllerAnimated:YES];
}

@end

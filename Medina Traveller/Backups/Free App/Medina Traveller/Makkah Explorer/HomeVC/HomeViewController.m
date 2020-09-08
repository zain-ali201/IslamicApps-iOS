//
//  HomeViewController.m
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/10/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InterestPlacesVC.h"

#import "SettingsVC.h"
#import "AddLocationVC.h"
#import "PrayerTimeVC.h"
#import "UmraStepsVC.h"
#import "HajjStepsVC.h"

static NSString const *api_key =@"AIzaSyAnNzksYIn-iEWWIvy8slUZM44jH6WjtP8"; // public youtube api key

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
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
    
    
    //Start video frame
    
    [self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=LrWEFQYzqro"];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    
    NSError *sessionError = nil;
    
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    if (!success)
     {
        NSLog(@"setCategory error %@", sessionError);
     }
    
    success = [audioSession setActive:YES error:&sessionError];
    
    if (!success)
     {
        NSLog(@"setActive error %@", sessionError);
     }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appIsInBakcground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillBeInBakcground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)videoBtnAction:(id)sender
{
    [self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=bDpQNwNU9ls"];
    //
   // [self.player loadWithVideoId:@"VopbGPJVkzM"];
   // [videoView addSubview:self.player];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    
    NSError *sessionError = nil;
    
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    if (!success)
    {
        NSLog(@"setCategory error %@", sessionError);
    }
    
    success = [audioSession setActive:YES error:&sessionError];
    
    if (!success)
    {
        NSLog(@"setActive error %@", sessionError);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appIsInBakcground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillBeInBakcground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

#pragma mark -
#pragma mark Getters and Setters

- (YTPlayerView *)player
{
    if(!_player)
    {
        _player = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, videoView.frame.size.width, videoView.frame.size.height)];
        [_player setBackgroundColor:[UIColor blackColor]];
        _player.delegate = self;
        _player.autoplay = NO;
        _player.modestbranding = YES;
        _player.allowLandscapeMode = YES;
        _player.forceBackToPortraitMode = NO;
        _player.allowAutoResizingPlayerFrame = YES;
        _player.playsinline = NO;
        _player.fullscreen = YES;
        _player.playsinline = YES;
    }
    
    return _player;
}


#pragma mark -
#pragma mark Player delegates

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    [_player setPlaybackQuality:kYTPlaybackQualityHighRes];
}

//- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
//{
//    [self.player nextVideo];
//}


#pragma mark -
#pragma mark Helper Functions

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    // loading a set of videos to the player after the player has finished loading
    // NSArray *videoList = @[@"m2d0ID-V9So", @"c7lNU4IPYlk"];
    // [self.player loadPlaylistByVideos:videoList index:0 startSeconds:0.0 suggestedQuality:kYTPlaybackQualityHD720];
}

#pragma mark -
#pragma mark Notifications

- (void)appIsInBakcground:(NSNotification *)notification
{
    [self.player playVideo];
}

- (void)appWillBeInBakcground:(NSNotification *)notification
{
    // self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(keepPlaying) userInfo:nil repeats:YES];
    // self.isInBackgroundMode = YES;
    // [self.player playVideo];
}

- (void)keepPlaying
{
    if(self.isInBackgroundMode)
    {
        [self.player playVideo];
        self.isInBackgroundMode = NO;
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(IBAction)menuBtnAction:(UIButton*)button
{
    if(button.tag == 1001)
    {
        InterestPlacesVC *locationsVC = [[InterestPlacesVC alloc]initWithNibName:@"InterestPlacesVC" bundle:[NSBundle mainBundle]];
        locationsVC.isShowRout = FALSE;
        [appDelegate.navController pushViewController:locationsVC animated:NO];
    }
    else if(button.tag == 1002)
    {
        AddLocationVC *placesVC = [[AddLocationVC alloc]initWithNibName:@"AddLocationVC" bundle:[NSBundle mainBundle]];
        [appDelegate.navController pushViewController:placesVC animated:NO];
    }
    else if(button.tag == 1004)
    {
        PrayerTimeVC *prayerVC = [[PrayerTimeVC alloc]initWithNibName:@"PrayerTimeVC" bundle:[NSBundle mainBundle]];
        [appDelegate.navController pushViewController:prayerVC animated:NO];
    }
    else if(button.tag == 1005)
    {
        SettingsVC *settingsVC = [[SettingsVC alloc]initWithNibName:@"SettingsVC" bundle:[NSBundle mainBundle]];
        [appDelegate.navController pushViewController:settingsVC animated:NO];
    }
}

-(IBAction)hajjStepsBtnAction:(id)sender
{
    HajjStepsVC *hajjVC = [[HajjStepsVC alloc]initWithNibName:@"HajjStepsVC" bundle:[NSBundle mainBundle]];
    [appDelegate.navController pushViewController:hajjVC animated:YES];
    
}
-(IBAction)umraStepsBtnAction:(id)sender
{
    UmraStepsVC *umrahVC = [[UmraStepsVC alloc]initWithNibName:@"UmraStepsVC" bundle:[NSBundle mainBundle]];
    [appDelegate.navController pushViewController:umrahVC animated:YES];
}

@end

//
//  HomeViewController.h
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/10/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "YTPlayerView.h"

@interface HomeViewController : UIViewController <YTPlayerViewDelegate,CLLocationManagerDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *videoView;
}

//@property (nonatomic, strong) YTPlayerView *player;
@property(nonatomic, strong) IBOutlet YTPlayerView *player;
@property (nonatomic) int counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInBackgroundMode;
@property (strong, nonatomic) NSTimer *timer2;
@end

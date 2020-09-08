//
//  LoadingView.m
//  NewsFlipper
//
//  Created by Zain Ali on 12/18/13.
//
//

#import "LoadingView.h"
#import "AppDelegate.h"

@implementation LoadingView

#pragma mark ---------
#pragma mark Fade View functions

+(void)showFadeView:(NSString *) msg
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    int device = [appDelegate CheckDevice];
    
    float hieght;
    float width;
    float xPosition;
    float yPosition;
    float loaderWidth;
    float loaderHeight;
    float msgWidth;
    float msgHeight;
    float msgYPosition;
    float font;
    
    if (device == 1)
    {
        hieght = 1024.0;
        width = 768.0;
        xPosition = 384.0;
        yPosition = 500.0;
        loaderHeight = 64.0;
        loaderWidth = 64.0;
        msgWidth = 768.0;
        msgHeight = 64.0;
        msgYPosition = 532.0;
        font = 24.0;
    }
    else if (device == 4)
    {
        hieght = 480.0;
        width = 320.0;
        xPosition = 160.0;
        yPosition = 200.0;
        loaderHeight = 32.0;
        loaderWidth = 32.0;
        msgWidth = 320.0;
        msgHeight = 32.0;
        msgYPosition = 210.0;
        font = 12.0;
    }
    else if (device == 5)
    {
        hieght = 568.0;
        width = 320.0;
        xPosition = 160.0;
        yPosition = 250.0;
        loaderHeight = 32.0;
        loaderWidth = 32.0;
        msgWidth = 320.0;
        msgHeight = 32.0;
        msgYPosition = 260.0;
        font = 12.0;
    }
    
	UIView *fadeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,hieght) ];
	fadeView.backgroundColor = [UIColor blackColor];
	[fadeView setAlpha:0.5];
//    [fadeView setOpaque:YES];
	fadeView.tag = 999;
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackTranparent.png"]];
//    [fadeView addSubview:imgView];
//    [imgView release];
	
    //Add Activity Indicator
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, loaderWidth, loaderHeight)];
	[activityIndicator setCenter:CGPointMake(xPosition, yPosition)];
	if (device == 1)
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    else
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	[fadeView addSubview:activityIndicator];
	[activityIndicator startAnimating];
    
//    NSArray *imagesArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"a.png"],[UIImage imageNamed:@"b.png"],[UIImage imageNamed:@"c.png"],[UIImage imageNamed:@"d.png"],[UIImage imageNamed:@"e.png"],[UIImage imageNamed:@"f.png"],[UIImage imageNamed:@"g.png"],[UIImage imageNamed:@"h.png"],[UIImage imageNamed:@"i.png"],[UIImage imageNamed:@"j.png"],[UIImage imageNamed:@"k.png"],[UIImage imageNamed:@"l.png"],[UIImage imageNamed:@"m.png"],[UIImage imageNamed:@"n.png"],[UIImage imageNamed:@"o.png"],[UIImage imageNamed:@"p.png"],[UIImage imageNamed:@"q.png"],[UIImage imageNamed:@"r.png"], nil];
//    
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(105.0f, 200.0f, 108.0f, 65.0f)];
//    
//    imgView.animationImages = imagesArray;
//    imgView.animationDuration = 1.0;
//    [imgView startAnimating];
//    //[imgView setImage:[UIImage imageNamed:@"g.png"]];
//    [fadeView addSubview:imgView];
//    //[imgView release];
    
	UILabel *lblMessage=[[UILabel alloc] initWithFrame:CGRectMake(0, msgYPosition, msgWidth, msgHeight)];
	[lblMessage setText:msg];
    [lblMessage setFont:[UIFont boldSystemFontOfSize:font]];
	[lblMessage setTextAlignment:NSTextAlignmentCenter];
	[lblMessage setTextColor:[UIColor whiteColor]];
	[lblMessage setBackgroundColor:[UIColor clearColor]];
	[fadeView addSubview:lblMessage];
    
	//STARTS THE SYNC METHOD
	[appDelegate.window addSubview:fadeView];
	[fadeView setAlpha:0.0];	
	[UIView beginAnimations:@"fadeOutSync" context:NULL];
	//[UIView setAnimationWillStartSelector:@selector (syncFadeViewDidStart1:context:) ];
	//[UIView setAnimationDidStopSelector:@selector (syncFadeViewDidEnd1:finished:context:) ];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[fadeView setAlpha:0.6];
	[UIView commitAnimations];
}

+(void)hideFadeView
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	UIView *fadeView=[appDelegate.window viewWithTag:999];
    if(fadeView)
    {
        [UIView beginAnimations:@"fadeInSync" context:NULL];
        [UIView setAnimationWillStartSelector:@selector (syncFadeViewDidStart2:context:) ];
        //[UIView setAnimationDidStopSelector:@selector (syncFadeViewDidEnd2:finished:context:) ];
        //[UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.0];
        [fadeView setAlpha:0.0];
        [UIView commitAnimations];
        [fadeView removeFromSuperview];
    }
}

@end

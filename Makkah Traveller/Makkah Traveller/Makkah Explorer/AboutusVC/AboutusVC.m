//
//  AboutusVC.m
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/12/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import "AboutusVC.h"

@implementation AboutusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *pickedYear = [NSDate date];
    lblYear.text = [NSString stringWithFormat:@"©  %@  Makkah Traveller. All rights reserved",[dateFormatter stringFromDate:pickedYear]];
    
    lblVersion.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [self.bannerView setAdUnitID:adUnitID];
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.bannerView loadRequest:[GADRequest request]];
    
//    self.interstitial = [[GADInterstitial alloc]
//                         initWithAdUnitID:interstitialUnitID];
//    self.interstitial.delegate = self;
//    GADRequest *request1 = [GADRequest request];
//    [self.interstitial loadRequest:request1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
//    NSLog(@"interstitialDidReceiveAd");
//    
//    if (self.interstitial.isReady) {
//        [self.interstitial presentFromRootViewController:self];
//    }
//}

-(IBAction)backBtnAction:(id)sender
{
    [appDelegate.navController popViewControllerAnimated:YES];
}

-(IBAction)facebookBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/sprintsols"]];
}

-(IBAction)twitterBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/SprintSols"]];
}

-(IBAction)linkedInBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/102575201299488404985"]];
}

-(IBAction)sendMail:(UIButton*)button
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate =self;
        
        [mailController setSubject:@"Makkah Traveller Feedback"];
        [mailController setToRecipients:[NSArray arrayWithObjects:@"info@sprintsols.com",nil]];
        
        NSString *emailBody = [NSString stringWithFormat:@"<html><body><br/><br/><br/><p>Sent Via <a href='http://www.sprintsols.com'>Makkah Traveller</a></p> </body></html>"];
        [mailController setMessageBody:emailBody isHTML:YES];
        [appDelegate.navController presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign In." message:@"Please add mail account to your device. Go to device settings and add account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Thank You" message:@"Email received successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [appDelegate.navController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)webBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sprintsols.com"]];
}


@end

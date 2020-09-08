//
//  AboutusVC.h
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/12/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface AboutusVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *lblYear;
    IBOutlet UILabel *lblVersion;
}
@end

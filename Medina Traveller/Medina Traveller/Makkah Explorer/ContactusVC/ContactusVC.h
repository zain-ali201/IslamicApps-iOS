//
//  ContactusVC.h
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/12/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ContactusVC : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
   AppDelegate *appDelegate;
    
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextView *txtMsg;
    
    IBOutlet UIActivityIndicatorView *loader;
}
@end

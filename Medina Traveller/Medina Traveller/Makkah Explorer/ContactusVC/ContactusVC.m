//
//  ContactusVC.m
//  Makkah Explorer
//
//  Created by ARAM Shehzad on 08/12/2015.
//  Copyright © 2015 ARAM Shehzad. All rights reserved.
//

#import "ContactusVC.h"

@implementation ContactusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    loader.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtnAction:(id)sender
{
    [appDelegate.navController popViewControllerAnimated:YES];
}

-(IBAction)submitBtnAction:(UIButton*)button
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    
    BOOL emailIndicator = [emailTest evaluateWithObject:txtEmail.text];
    
    if ([txtName.text isEqualToString:@""])
    {
        alert.message = @"Please enter your Name.";
        [alert show];
    }
    else if (!emailIndicator)
    {
        alert.message = @"Please enter a valid email address.";
        [alert show];
    }
    else if ([txtPhone.text isEqualToString:@""])
    {
        alert.message = @"Please enter your contact number.";
        [alert show];
    }
    else if ([txtPhone.text isEqualToString:@""])
    {
        alert.message = @"Please enter message.";
        [alert show];
    }
    else
    {
        loader.alpha = 1;
        [self callWebservice];
    }
}

-(void)callWebservice
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:txtName.text forKey:@"name"];
    [dict setValue:txtEmail.text forKey:@"email"];
    [dict setValue:txtPhone.text forKey:@"mobile"];
    [dict setValue:txtMsg.text forKey:@"message"];
    
    NSDictionary *dictResult = [appDelegate callWebService:[NSString stringWithFormat:@"%@/contact_us",apiURL] RequestData:dict ImageParameterName:@"" ImagesArray:nil ActivityIndicator:YES Message:@"Please wait..."];
    NSLog(@"dictResult :%@",dictResult);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (dictResult != nil)
    {
        loader.alpha = 0;
        BOOL status = [[dictResult objectForKey:@"status"]boolValue];
        
        if (status)
        {
            alert.title = @"Thankyou";
            alert.message = @"Your message has been delivered.";
            [alert show];
            [txtName setText:@""];
            [txtEmail setText:@""];
            [txtPhone setText:@""];
            [txtMsg setText:@""];
        }
        else
        {
            alert.title = @"System Error";
            alert.message = @"Please try later.";
            [alert show];
        }
    }
    else
    {
        loader.alpha = 0;
        alert.title = @"Network Error";
        alert.message = @"Please check your Wifi or Network connection is active.";
        [alert show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    textField.inputAccessoryView = keyboardToolbar;
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    textView.inputAccessoryView = keyboardToolbar;
    return YES;
}

-(void)yourTextViewDoneButtonPressed
{
    [txtEmail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMsg resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtEmail resignFirstResponder];
    [txtName resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMsg resignFirstResponder];
}

@end

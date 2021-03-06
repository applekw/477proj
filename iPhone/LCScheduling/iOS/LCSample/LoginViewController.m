//
//  LoginViewController.m
//  LCSample
//
//  Created by Ian Cundiff on 1/19/12.
//  Copyright (c) 2012 Rose-Hulman. All rights reserved.
//

#import "LoginViewController.h"
#import "KerberosAccountManager.h"

@implementation LoginViewController

@synthesize usernameField,passwordField, overlay, wheel, helpButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(credentialsSubmitted:) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(credentialsSubmitted:) name:@"LoginFailure" object:nil];
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameField) {
        [textField resignFirstResponder];
        return NO;
    } else {
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        overlay.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        
        [self.view addSubview:overlay];
        
        wheel = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        wheel.frame=CGRectMake(145, 160, 25, 25);
        wheel.tag  = 1;
        wheel.color = [UIColor whiteColor];
        
        [overlay addSubview:wheel];
        [wheel startAnimating];

        
        LCAuth* auth = [LCAuth alloc];
        auth.username = usernameField.text;
        auth.password = passwordField.text;
        
        [[DBInteract sharedInstance] authenticateWithCredentials:auth];
        
        [textField resignFirstResponder];
       
        return NO;
    }
    return NO;
}

-(IBAction)loginPressed:(id)sender {
    LCAuth* auth = [LCAuth alloc];
    auth.username = usernameField.text;
    auth.password = passwordField.text;
    
    [[DBInteract sharedInstance] authenticateWithCredentials:auth];
}

-(void)credentialsSubmitted:(NSNotification *) notification {
    if ([notification.name isEqual:@"LoginSuccess"]) {
        [wheel removeFromSuperview];
        [overlay removeFromSuperview];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [wheel removeFromSuperview];
        [overlay removeFromSuperview];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                          message:@"The username or password you entered was incorrect, please try again."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
        
}

-(IBAction)helpPressed:(id)sender {
    [self presentModalViewController:[HelpScreenViewController alloc] animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end

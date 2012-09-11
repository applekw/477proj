//
//  TutorProfileViewController.m
//  LCSample
//
//  Created by Ian Cundiff on 11/1/11.
//  Copyright (c) 2011 Rose-Hulman. All rights reserved.
//

#import "TutorProfileViewController.h"

@implementation TutorProfileViewController
@synthesize majorsLabel,titleLabel,yearLabel,pictureFrame, about, tutor, timeslots;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Tutor Profile" ,@"Tutor Profile");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coursesUpdated) name:@"CoursesUpdated" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeslotsReturned) name:@"TimeslotsReturned" object:nil];
    }
    return self;
}

-(IBAction)emailPressed:(id)sender {
    MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
    email.mailComposeDelegate = self;
    
    [email setToRecipients:[[NSArray alloc] initWithObjects:tutor.email, nil]];
    
    [self presentModalViewController:email animated:YES];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
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
    [titleLabel setText:tutor.name];
    [majorsLabel setText:[NSString stringWithFormat :@"Major: %@",tutor.major]];
    [yearLabel setText:[NSString stringWithFormat :@"Class: %@",tutor.year]];
    NSString *imageURL = [@"http://lcwebapp.csse.rose-hulman.edu/tutor_pics/" stringByAppendingString:[tutor.tid stringByAppendingString:@".jpg"]];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
    pictureFrame.image = [UIImage imageWithData: imageData];
    [about setText:tutor.about_tutor];
    [imageData release];
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

-(void)timeslotsReturned 
{
    
    timeslots = [[DBInteract sharedInstance] timeslots];
    
    TutorScheduleViewController *scheduleView = [[TutorScheduleViewController alloc] init];
    scheduleView.tutorID = tutor.tid;
    scheduleView.timeslots = timeslots;

    
    [self presentModalViewController:scheduleView animated:YES];
}


-(void)setTutor:(Tutor *)tutorEntered
{
    tutor = tutorEntered;
}


-(IBAction)donePressed:(id)sender 
{
    
    [self.view removeFromSuperview];
    
}
-(IBAction)getSchedulePressed:(id)sender
{   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSString *today = [NSString stringWithFormat:@"%d-%d-%d",[components year],[components month],[components day]];
    [[DBInteract sharedInstance] getTutorBookedTimeslotsByID:tutor.tid andDate:today];
}

-(void)coursesUpdated {
    
    NSMutableArray *courses = [NSMutableArray alloc];
    courses = [[DBInteract sharedInstance] currentCoursesTutored];
    
    tutor.courses_tutored = courses;
    
   
}



@end

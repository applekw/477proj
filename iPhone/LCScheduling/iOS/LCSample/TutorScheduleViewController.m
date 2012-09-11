//
//  TutorScheduleViewController.m
//  LCSample
//
//  Created by Ian Cundiff on 11/1/11.
//  Copyright (c) 2011 Rose-Hulman. All rights reserved.
//

#import "TutorScheduleViewController.h"

@implementation TutorScheduleViewController

int bookedID = 0;

@synthesize tutorID, dateLabel, todaysDate, bookingAlert, unbookingAlert, flag, timeslots, scheduleView, tuteeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeslotBooked) name:@"TimeslotBooked" object:nil];

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
    
    [self.scheduleView reloadData];
    
    todaysDate = [[UILabel alloc] init];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSString *today = [NSString stringWithFormat:@"%d/%d/%d",[components month],[components day],[components year]];
 
    [dateLabel setText:today];
    
    [self initAlerts];
    
    
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

-(IBAction)donePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) initAlerts{
    bookingAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Booking"
                                              message:@"Are you sure you want to book this timeslot?"
                                             delegate:self
                                    cancelButtonTitle:@"Yes"
                                    otherButtonTitles:@"No", nil];
    
    unbookingAlert =  [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                 message:@"Are you sure you want to cancel this tutoring appointment?"
                                                delegate:self
                                       cancelButtonTitle:@"Yes"
                                       otherButtonTitles:@"No", nil];
}

//-(void) bookSlot

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{   
    
    if(alertView == bookingAlert)
    {
        if(buttonIndex == 0)
        {
            
            [[DBInteract sharedInstance] bookTutorByName:tutorID tutee:tuteeName timeslot:[NSString stringWithFormat:@"",bookedID] andDate:todaysDate.text];
            
        }
        else
        {
            bookedID = 0;
        }
        
    }
    
    else if(alertView == unbookingAlert)
    {
        if(buttonIndex == 0)
        {
            //unbook
        }
        else
        {
            //unbook?
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [timeslots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
        
    for (Timeslot *t in timeslots) {
        if ([t.timeslotID intValue]-1 == indexPath.row) {
            NSString *cellValue = [t tuteeName];
            cell.textLabel.text = cellValue;
        }
    }
    
      
    
    return cell;
}

-(void)timeslotBooked 
{
    [scheduleView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqual:@"Available"]) {
        bookedID = indexPath.row;
        [bookingAlert show];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unavailable"
                                                          message:@"Sorry, but the tutor is unavailable at the selected time."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}

@end

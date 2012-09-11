//
//  TutorScheduleViewController.h
//  LCSample
//
//  Created by Ian Cundiff on 11/1/11.
//  Copyright (c) 2011 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeslotButton.h"
#import "DBInteract.h"

@interface TutorScheduleViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSString *tutorID;
@property (strong, nonatomic) IBOutlet UILabel *todaysDate;
@property (strong, nonatomic) UIAlertView *bookingAlert;
@property (strong, nonatomic) UIAlertView *unbookingAlert;
@property (strong, nonatomic) NSMutableArray *timeslots;
@property (strong, nonatomic) IBOutlet UITableView *scheduleView;
@property (strong, nonatomic) NSString *tuteeName;
@property BOOL flag;


-(IBAction)donePressed:(id)sender;


@end


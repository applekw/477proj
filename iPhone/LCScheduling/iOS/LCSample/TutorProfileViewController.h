//
//  TutorProfileViewController.h
//  LCSample
//
//  Created by Ian Cundiff on 11/1/11.
//  Copyright (c) 2011 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"
#import "DBInteract.h"
#import "Course.h"
#import "TutorScheduleViewController.h"
#import <MessageUI/MessageUI.h>



@interface TutorProfileViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *majorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pictureFrame;
@property (strong, nonatomic) IBOutlet UITextView *about;
@property (strong, nonatomic) Tutor *tutor;
@property (strong, nonatomic) NSMutableArray *timeslots;

-(void)setTutor:(Tutor *)tutorEntered;
-(IBAction)getSchedulePressed:(id)sender;
-(IBAction)emailPressed:(id)sender;

-(void)timeslotsReturned;
-(void)coursesUpdated; 
@end

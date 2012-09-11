//
//  DBInteract.h
//  LCSample
//
//  Created by Ian Cundiff on 1/24/12.
//  Copyright (c) 2012 Rose-Hulman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/Support/JSON/JSONKit/RKJSONParserJSONKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Support/JSON/JSONKit/JSONKit.h>
#import "LCArgs.h"
#import "LCAuth.h"
#import "Tutor.h"
#import "Schedule.h"
#import "Timeslot.h"
#import "LCBooking.h"
#import "LCBooked.h"

@interface DBInteract : NSObject <RKObjectLoaderDelegate, RKRequestDelegate>{
    
    int responseType;
    //1 for tutor search, 2 for courses tutored lookup, 3 for schedule lookup
    //ghetto but (hopefully) effective
}

@property(strong, nonatomic) NSString *currentUser;
@property(strong, nonatomic) NSMutableArray *possibleTutors;
@property(strong, nonatomic) NSMutableArray *currentCoursesTutored;
@property(strong, nonatomic) NSMutableArray *timeslots;
@property(strong, nonatomic) Schedule *schedule;

-(NSMutableArray*)getTutorsWithName:(NSString*)name course:(NSString*)course andDateAvailable:(NSString*)date; //TODO: consider changing this to an NSDate...

-(NSMutableArray*)getCoursesTutoredByName:(NSString*)name;

-(void)bookTutorByName:(NSString*) name tutee:(NSString*) tutee timeslot:(NSString *) timeslot andDate:(NSString*) date;

-(void)checkIfBookedByTutorID:(NSString*) name timeslot:(NSString *) timeslot andDate:(NSDate*) date;

-(void)authenticateWithCredentials:(LCAuth*)credentials; //consider bool

-(void)getTutorBookedTimeslotsByID:(NSString*)tutorID andDate:(NSString*)date;

//-(Schedule*)getScheduleForDate:(NSString*)date; //same concern as previous method

-(void)postWithArray:(NSArray*)args;

+ (id)sharedInstance;


@end

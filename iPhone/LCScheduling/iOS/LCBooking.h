//
//  LCBooking.h
//  LearningCenter
//
//  Created by Ian Cundiff on 4/12/12.
//  Copyright (c) 2012 Rose-Hulman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timeslot.h"

@interface LCBooking : NSObject

@property(nonatomic, retain) NSString* LCTutorID;
@property(nonatomic, retain) NSString* LCTuteeUName;
@property(nonatomic, retain) NSString* LCTimeslotID;
@property(nonatomic, retain) NSString* LCDate;


@end

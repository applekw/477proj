//
//  LCBooked.h
//  LearningCenter
//
//  Created by Ian Cundiff on 5/11/12.
//  Copyright (c) 2012 Rose-Hulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBooked : NSObject

@property(nonatomic, retain) NSString* LCTutorID;
@property(nonatomic, retain) NSString* LCTimeslotID;
@property(nonatomic, retain) NSDate* LCDate;

@end

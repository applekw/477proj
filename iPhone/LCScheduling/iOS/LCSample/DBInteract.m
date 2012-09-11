//
//  DBInteract.m
//  LCSample
//
//  Created by Ian Cundiff on 1/24/12.
//  Copyright (c) 2012 Rose-Hulman. All rights reserved.
//
//  Handles all database connections
//

#import "DBInteract.h"

@implementation DBInteract

int done = 0;
NSString *base_url = @"http://lcwebapp.csse.rose-hulman.edu";

@synthesize currentUser, possibleTutors, schedule,currentCoursesTutored, timeslots;


- (id) init
{
    
    if ( self = [super init] )
    {
        
    }
    return self;
}

+ (id) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}


/**
 TODO: Get the tutors (plural) that fit the given criteria from the server and return them as an array...
 **/
-(NSMutableArray*)getTutorsWithName:(NSString*)name course:(NSString*)course andDateAvailable:(NSString*)date {
    responseType = 1;
    
    //initialize object manager with url of web service
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];
    
    //set serlialization for each type of object    
    RKObjectMapping* argSerializationMapping = [RKObjectMapping mappingForClass:[LCArgs class] ];
    [argSerializationMapping mapAttributes:@"LCTutorName", @"LCCourseNumber", nil];
    
    RKObjectMapping* tutorSerializationMapping = [RKObjectMapping mappingForClass:[Tutor class] ];
    [tutorSerializationMapping mapAttributes:@"name", @"year", @"major", @"email", nil];
    
    
    //set parser to JSON for "text/html" in case it comes in that way
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //register the mappings with the object managers mapping provider
    [manager.mappingProvider setSerializationMapping:argSerializationMapping forClass:[LCArgs class]];
    [manager.mappingProvider setSerializationMapping:tutorSerializationMapping forClass:[Tutor class]];
    
    //let the manager know what MIME type to look out for
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
//    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
//    [router routeClass:[LCArgs class] toResourcePath:@"/rest/get_tutors_by_name" forMethod:RKRequestMethodPOST]; 

    
    //create the object to post and post it with an appropriate object mapping 
    LCArgs *args = [LCArgs new];
    if (name.length != 0 || course.length != 0) {
        if (name.length != 0) {
            RKObjectRouter* router = [[RKObjectRouter new] autorelease];
            [router routeClass:[LCArgs class] toResourcePath:@"/rest/get_tutors_by_name" forMethod:RKRequestMethodPOST];  
            manager.router = router;
            args.LCTutorName = name;
        }
        if (course.length != 0) {
            RKObjectRouter* router = [[RKObjectRouter new] autorelease];
            [router routeClass:[LCArgs class] toResourcePath:@"/rest/get_tutors_by_course" forMethod:RKRequestMethodPOST]; 
            manager.router = router;
            args.LCCourseNumber = course;
        }
        
        if (name.length != 0 && course.length != 0) {
            RKObjectRouter* router = [[RKObjectRouter new] autorelease];
            [router routeClass:[LCArgs class] toResourcePath:@"/rest/get_tutors_by_name_and_course" forMethod:RKRequestMethodPOST]; 
            manager.router = router;
        }
        
        
        NSArray *postArray = [NSArray arrayWithObjects:manager, args, nil];
        [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please enter at least one search term!"
                                                          message:nil
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    
    return possibleTutors;
    
}

-(NSMutableArray*)getCoursesTutoredByName:(NSString*)name {
    responseType = 2;
  
    //initialize object manager with url of web service
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];
    
    //set serlialization for each type of object    
    RKObjectMapping* argSerializationMapping = [RKObjectMapping mappingForClass:[LCArgs class] ];
    [argSerializationMapping mapAttributes:@"LCTutorID", nil];
    
    RKObjectMapping* courseSerializationMapping = [RKObjectMapping mappingForClass:[Course class] ];
    [courseSerializationMapping mapAttributes:@"department", @"course_number", @"course_description",nil];
    
    //set parser to JSON for "text/html" in case it comes in that way
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //register the mappings with the object managers mapping provider
    [manager.mappingProvider setSerializationMapping:argSerializationMapping forClass:[LCArgs class]];
    [manager.mappingProvider setSerializationMapping:courseSerializationMapping forClass:[Course class]];
    
    //let the manager know what MIME type to look out for
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
    //create a router and set it to specific routes on the website for given request types
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[LCArgs class] toResourcePath:@"/rest/get_tutor_courses_tutored" forMethod:RKRequestMethodPOST];  
    manager.router = router;
    
    
    
    //create the object to post and post it with an appropriate object mapping
    LCArgs *args = [LCArgs new];
    args.LCTutorName = name;
    
    
    NSArray *postArray = [NSArray arrayWithObjects:manager, args, nil];
    
    //@synchronized(self) {  
//    [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
    [self postWithArray:postArray];
    //}
    
    //    [self postWithArray:postArray];
    
    //this is making postObject sleep too...
    
    //    [manager performSelectorOnMainThread:@selector(postObject:delegate:) withObject:args withObject:self waitUntilDone:YES];
   
    
    
    return currentCoursesTutored;
    
}

-(void)getTutorBookedTimeslotsByID:(NSString*)tutorID andDate:(NSString*)date {
    responseType = 4;
    
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];
    
    RKObjectMapping* booking = [RKObjectMapping mappingForClass:[LCBooking class]];
    [booking mapAttributes:@"LCTutorID", @"LCDate", nil];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    [manager.mappingProvider setSerializationMapping:booking forClass:[LCBooking class]];
    
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[LCBooking class] toResourcePath:@"/rest/get_tutor_booked_timeslots" forMethod:RKRequestMethodPOST];   
    manager.router = router;
    
    LCBooking *checkTutor = [[LCBooking alloc] init];
    checkTutor.LCTutorID = tutorID;
    //date format
    checkTutor.LCDate = date;
    
    NSArray *postArray = [NSArray arrayWithObjects:manager, checkTutor, nil];
    
    [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
}

-(void)authenticateWithCredentials:(LCAuth *)credentials {
    responseType = 3;
    
    [self setCurrentUser:credentials.username];
    
    //initialize object manager with url of web service
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];

    RKObjectMapping* auth = [RKObjectMapping mappingForClass:[LCAuth class]];
    [auth mapAttributes:@"username", @"password", nil];
    
    
    //set parser to JSON for "text/html" in case it comes in that way
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //register the mappings with the object managers mapping provider
    [manager.mappingProvider setSerializationMapping:auth forClass:[LCAuth class]];
    
    //let the manager know what MIME type to look out for
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
    //create a router and set it to specific routes on the website for given request types
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[LCAuth class] toResourcePath:@"/rest/authenticate" forMethod:RKRequestMethodPOST];   
    manager.router = router;
    
    
    NSArray *postArray = [NSArray arrayWithObjects:manager, credentials, nil];
    
    [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
}

-(void)bookTutorByName:(NSString*) name tutee:(NSString*) tutee timeslot:(NSString *) timeslot andDate:(NSString*) date{
    responseType = 6;
    
    //initialize object manager with url of web service
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];
    
    RKObjectMapping* booking = [RKObjectMapping mappingForClass:[LCBooking class]];
    [booking mapAttributes:@"LCTutorID", @"LCTuteeUName", @"LCTimeslotID", @"LCDate", nil];
    
    
    //set parser to JSON for "text/html" in case it comes in that way
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //register the mappings with the object managers mapping provider
    [manager.mappingProvider setSerializationMapping:booking forClass:[LCBooking class]];
    
    //let the manager know what MIME type to look out for
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
    //create a router and set it to specific routes on the website for given request types
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[LCBooking class] toResourcePath:@"/rest/book_timeslot" forMethod:RKRequestMethodPOST];   
    manager.router = router;
    
    
    LCBooking *args = [LCBooking new];
    args.LCTutorID = name;
    args.LCTuteeUName = tutee;
    args.LCTimeslotID = timeslot;
    args.LCDate = date;
    
    
    NSArray *postArray = [NSArray arrayWithObjects:manager, args, nil];
    
    [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
    
    
}

-(void)checkIfBookedByTutorID:(NSString*) name timeslot:(NSString *) timeslot andDate:(NSDate*) date {
    responseType = 5;
    
    //initialize object manager with url of web service
    RKObjectManager *manager = [[RKObjectManager objectManagerWithBaseURL:base_url] retain];
    
    RKObjectMapping* auth = [RKObjectMapping mappingForClass:[LCBooked class]];
    [auth mapAttributes:@"LCTutorID", @"LCTimeslotID", @"LCDate", nil];
    
    
    //set parser to JSON for "text/html" in case it comes in that way
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //register the mappings with the object managers mapping provider
    [manager.mappingProvider setSerializationMapping:auth forClass:[LCBooked class]];
    
    //let the manager know what MIME type to look out for
    [manager setSerializationMIMEType:RKMIMETypeJSON]; 
    
    //create a router and set it to specific routes on the website for given request types
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[LCBooked class] toResourcePath:@"/rest/book_timeslot" forMethod:RKRequestMethodPOST];   
    manager.router = router;
    
    
    LCBooked *args = [LCBooked new];
    args.LCTutorID = name;
    args.LCTimeslotID = timeslot;
    args.LCDate = date;
    
    
    NSArray *postArray = [NSArray arrayWithObjects:manager, args, nil];
    
    [self performSelectorInBackground:@selector(postWithArray:) withObject:postArray];
}

-(void)postWithArray:(NSArray*)array {
    [[array objectAtIndex:0] postObject:[array objectAtIndex:1] delegate:self];
}



#pragma mark ObjectLoaderDelegate methods 

//TODO: handle problems and such here
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //    NSLog(@"error: %@",error);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    //    NSLog(@"loaded objects %@",((Auth_Result*)[objects objectAtIndex:1]).token);
    //    NSLog(@"objects: %@",objects);
}

//what made the call
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    //    NSLog(@"Auth_Result.token = %@",((LCAuth*)object).username);
    //    NSLog(@"object: %@",((LCAuth*)object).username);
    //    NSLog(@"object loaded: %@\n",object);
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
    //    NSLog(@"unexpected response...");
}

//TODO: extend this so that it handles different types of responses...
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {

//    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    
    possibleTutors = [[NSMutableArray alloc] init];
    
    
    //put everything from the response into an array
    
    
    //handle stuff based on response type
    if (responseType == 1){
        NSArray *tutors = [NSArray alloc];
        RKJSONParserJSONKit* parser = [RKJSONParserJSONKit new]; 
        tutors = [parser objectFromString:[response bodyAsString] error:NULL];
    
//        NSLog(@"object from string: %@",[parser objectFromString:[response bodyAsString] error:NULL]);
    
        for(int i = 0; i < tutors.count; i++) {
//            NSLog(@"in for loop\n");
            //make a new tutor
            Tutor *tempTutor = [Tutor new];
            tempTutor.tid = [[tutors valueForKey:@"TID"] objectAtIndex:i];
            tempTutor.name = [[tutors valueForKey:@"name"] objectAtIndex:i];
            tempTutor.year = [[tutors valueForKey:@"year"] objectAtIndex:i];
            tempTutor.email = [[tutors valueForKey:@"email"] objectAtIndex:i];
            tempTutor.major = [[tutors valueForKey:@"major"] objectAtIndex:i];
            tempTutor.about_tutor = [[tutors valueForKey:@"about_tutor"] objectAtIndex:i];
            tempTutor.courses_tutored = [[tutors valueForKey:@"courses_tutored"] objectAtIndex:i];
            tempTutor.email = [tempTutor.tid stringByAppendingString:@"@rose-hulman.edu"]; 
            

            [possibleTutors addObject:tempTutor];
//            NSLog(@"possible tutors: %@",[[possibleTutors objectAtIndex:i] name]);
        }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorsUpdated" object:nil];
    
    }
    
    else if (responseType == 2){
        
        //TODO: wipe the list of current courses here
        NSArray *courses = [NSArray alloc];
        RKJSONParserJSONKit* parser = [RKJSONParserJSONKit new]; 
        courses = [parser objectFromString:[response bodyAsString] error:NULL];
        
//        NSLog(@"object from string: %@",[parser objectFromString:[response bodyAsString] error:NULL]);
        
        for(int i = 0; i < courses.count; i++) {
            //make a new course
            Course *tempCourse = [Course new];
            tempCourse.department = [[courses valueForKey:@"department"] objectAtIndex:i];
            tempCourse.courseNumber = [[courses valueForKey:@"course_number"] objectAtIndex:i];
            tempCourse.courseDescription = [[courses valueForKey:@"course_description"] objectAtIndex:i];
            
            //add the course to the array
            [currentCoursesTutored addObject:tempCourse];
            
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CoursesUpdated" object:nil];
    }
    
    else if (responseType == 3) {
        
        
        
        if ([[response bodyAsString] isEqual:@"true"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
        } else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFailure" object:nil];
    } else if (responseType == 4){
        NSArray *tutorTimeslots = [NSArray alloc];
        RKJSONParserJSONKit* parser = [RKJSONParserJSONKit new]; 
        tutorTimeslots = [parser objectFromString:[response bodyAsString] error:NULL];
        
        timeslots = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 10; i++) {
            Timeslot *available = [[Timeslot alloc] init];
            available.tuteeName = @"Available";
            available.timeslotID = [NSString stringWithFormat:@"%d",i+1];
            [timeslots addObject:available];
        }
        
        for(int i = 0; i < tutorTimeslots.count; i++) {
            Timeslot *tempTimeslot = [Timeslot new];
            tempTimeslot.tuteeName = [[tutorTimeslots valueForKey:@"tutee_uname"] objectAtIndex:i];
            tempTimeslot.timeslotID = [[tutorTimeslots valueForKey:@"TSID"] objectAtIndex:i];

            [timeslots insertObject:tempTimeslot atIndex:[tempTimeslot.timeslotID intValue]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeslotsReturned" object:nil];
        
    } else if (responseType == 6){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeslotBooked" object:nil];
    }
    
    
    
    
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    //    NSLog(@"sent body data %d",totalBytesWritten);
}

@end

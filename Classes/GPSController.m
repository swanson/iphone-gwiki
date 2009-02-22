//
//  GPSController.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GPSController.h"

@implementation GPSController

@synthesize locationManager, delegate;

- (id) init {
	if(self = [super init])
	{
		// initialize crap
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kDesiredAccurracy;
		updateThreshold = kUpdateThreshold;
		[locationManager startUpdatingLocation];
		updating = YES;
	}
	return self;
}


- (id) initWithUpdateInterval:(CLLocationDistance) threshold {
	if(self = [super init])
	{
		updateThreshold = threshold;
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kDesiredAccurracy;
		[locationManager startUpdatingLocation];
		updating = YES;
	}
	return self;
}

/* CLLocationManager Delegate Methods */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Handle Error");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	CLLocationCoordinate2D coordinate = [newLocation coordinate];
	CLLocationAccuracy horizontalAccuracy = [newLocation horizontalAccuracy];
	
	// if old location does not exist
	if(!oldLocation | [oldLocation getDistanceFrom:newLocation] > updateThreshold)
	{
		NSLog(@"Updating Location");
		// filter here if necessary
		[[self delegate] getNewCoordinate:coordinate withAccuracy:horizontalAccuracy];
	}
}

- (void) getNewCoordinate: (CLLocationCoordinate2D *)coordinate withAccuracy:(CLLocationAccuracy) accuracy {
	// just ignore the coordinates passed in
	NSLog(@"Coordinates ignored");
}

- (void) stopUpdating {
	[locationManager stopUpdatingLocation];
	updating = NO;
}

- (void) startUpdating {
	[locationManager startUpdatingLocation];
	updating = YES;
}

- (BOOL) isUpdating {
	return updating;
}

/* Singleton Methods */
static GPSController * sharedController = nil;

+ (GPSController *) sharedInstance {
	@synchronized(self)
	{
		if(sharedController == nil) {
			sharedController = [[GPSController alloc] init];
		}
	}
	return sharedController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [super allocWithZone:zone];
            return sharedController;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end

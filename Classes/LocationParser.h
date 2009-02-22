//
//  LocationParser.h
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "geowikiAppDelegate.h"
#import "Location.h"
#import "geowikiGlobals.h"

@interface LocationParser : NSObject {
	Location * currentLocation;
	NSMutableString * currentPropertyValue;
	NSURL * url;
}

@property(nonatomic, retain) Location * currentLocation;
@property(nonatomic, retain) NSMutableString * currentPropertyValue;
@property(nonatomic, retain) NSURL * url;

// method declarations
- (void) parseLocations;
- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate andAccuracy:(CLLocationAccuracy) accuracy;

@end

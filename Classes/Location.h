//
//  Location.h
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "geowikiGlobals.h"

@interface Location : NSObject {
	NSString * _title;
	NSURL * _url;
	double _distance;
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property(nonatomic, getter=getTitle, setter=setTitle:, copy) NSString * _title;
@property(nonatomic, getter=getURL, setter=setURL:, copy) NSURL * _url;

- (id) initWithTitle:(NSString *)title latitude:(double) latitude longitude:(double) longitude withURL:(NSURL *)url andDistance:(float) distance;

- (CLLocation *) getLocation;
- (void) setLatitude:(CLLocationDegrees) latitude;
- (void) setLongitude:(CLLocationDegrees) longitude;
- (void) setDistance:(double) distance;
- (double) getDistance;
- (CLLocationDegrees) getLatitude;
- (CLLocationDegrees) getLongitude;

@end

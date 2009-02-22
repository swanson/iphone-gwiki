//
//  Location.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location
@synthesize  _title, _url;


// add other init methods as needed
- (id) init {
	if(self = [super init])
	{
		_title = nil;
		_url = nil;
		_latitude = _longitude = _distance = 0.0;
	}
	return self;
}

- (id) initWithTitle:(NSString *)title latitude:(double) latitude longitude:(double) longitude withURL:(NSURL *)url andDistance:(float) distance {
	if(self = [super init])
	{
		_title = title;
		_url = url;
		_distance = distance;
		_latitude = 0.0;
		_longitude = 0.0;
	}
	return self;
}

- (CLLocation *) getLocation
{
	return [[[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude] autorelease];
}

// --------- Setter Methods For Non-Object Types --------- //
- (void) setDistance:(double) distance {
	_distance = distance;
}

- (void) setLatitude:(double) latitude {
	_latitude = latitude;
}

- (void) setLongitude:(double) longitude {
	_longitude = longitude;
}

- (double) getDistance {
	return _distance;
}

- (CLLocationDegrees) getLatitude {
	return _latitude;
}

- (CLLocationDegrees) getLongitude {
	return _longitude;
}

@end

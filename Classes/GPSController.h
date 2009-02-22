//
//  GPSController.h
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kDesiredAccurracy kCLLocationAccuracyBest
#define kDistanceFilter 10
#define kUpdateThreshold 10

@protocol GPSControllerDelegate <NSObject>
@required
- (void) getNewCoordinate:(CLLocationCoordinate2D) coordinate withAccuracy: (CLLocationAccuracy) accuracy;


@end;

@interface GPSController : NSObject <CLLocationManagerDelegate> {
	CLLocationDistance updateThreshold;
	CLLocationManager *locationManager;
	id delegate;
	BOOL updating;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,assign) id <GPSControllerDelegate> delegate;


+ (GPSController *) sharedInstance;
- (void) stopUpdating;
- (void) startUpdating;
- (BOOL) isUpdating;

@end

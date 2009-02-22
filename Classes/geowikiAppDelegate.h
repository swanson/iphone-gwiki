//
//  geowikiAppDelegate.h
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "LocationParser.h"
#import "GPSController.h"
#import "RootViewController.h"
#import "AboutViewController.h"

enum GeoWikiMode {
	geoUpdateOff = 0x00,
	geoAutoUpdate = 0x01,
	geoLocationBased = 0x02
};

@interface geowikiAppDelegate : NSObject <UIApplicationDelegate, GPSControllerDelegate> { // , UITableViewDataSource> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *rootViewController;

	
	// datasource tableview will access
	NSMutableArray * locations;
	CLLocationManager * locationManager;
	GPSController * gpsc;
	int mode;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController * rootViewController;

@property(nonatomic, retain) NSMutableArray * locations;
@property(nonatomic, retain) CLLocationManager * locationManager;
@property(nonatomic, retain) GPSController * gpsc;


// make parser and list in here
- (NSUInteger) numberOfLocations;
- (id) locationForCell:(NSUInteger) cellNum;
- (void) getLocationsFromGWikiServer;
- (void) addLocation:(NSObject *)location;
- (void) setMode:(int) geoWikiMode;
- (int) getMode;
- (BOOL) isUpdating;
- (void) toggleUpdating;
-(void) sortLocationsByDistance;

@end


//
//  geowikiAppDelegate.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "geowikiAppDelegate.h"


@implementation geowikiAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize locations;
@synthesize locationManager;
@synthesize gpsc;
@synthesize rootViewController;


- init {
	if (self = [super init]) {
		// Initialization code
		gpsc = [GPSController sharedInstance];
		gpsc.delegate = self;
		mode = geoAutoUpdate;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	NSLog(@"CHECK THAT WE HAVE INTERNET CONNECTION");
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	
	
	self.locations = [NSMutableArray array];
	
	
	AboutViewController * avc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
	[[self navigationController] presentModalViewController:avc animated:NO];
	[avc release];
	
	[[self navigationController] pushViewController:[geowikiViewController sharedInstance] animated:NO];
	
}


// put internet connection test here

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


// TEST METHOD
- (void) getLocationsFromGWikiServer
{
	/// TODO:
	// check that server is available
	NSLog(@"CHECK THAT THE CONNECTION IS GOOD AND THE SERVER IS ONLINE!");
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	LocationParser * parser = [[LocationParser alloc] init];
	[parser parseLocations];
	[parser release];
	
	//[locations sortUsingFunction:locationDistanceCompare context:nil];
	[self sortLocationsByDistance];
	//[pool release];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	
}

- (void) updateLocationsFromServerNearCoordinate:(CLLocationCoordinate2D) coordinate withAccuracy:(CLLocationAccuracy) accuracy {

	NSLog(@"CHECK FOR CONNECTION!");
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableArray * prev = [[NSMutableArray arrayWithArray:locations] retain];
	LocationParser * parser = [[LocationParser alloc] initWithCoordinate: coordinate andAccuracy:accuracy];
	[parser parseLocations];
	[parser dealloc];
	[locations removeObjectsInArray:prev];
	[self sortLocationsByDistance];
	
	NSLog(@"IF THERE IS AN ERROR ON UPDATING MAKE SURE TO LOOK HERE, DEALLOC!! NOT RELEASE");
	
	// clean up
	[prev release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// reload tableview
	[[[self rootViewController] tableView] reloadData];
}


- (void) addLocation:(NSObject *)location {
	[self.locations addObject:location];
}

// tableview will use this to display rows
- (NSUInteger) numberOfLocations
{
	if(locations != nil)
		return [locations count];
	return 0;
}

// return the location that the selected cell needs information from
- (id) locationForCell:(NSUInteger) cellNum {
	return [locations objectAtIndex:cellNum];
}

/* gpsdelegate methods */
- (void) getNewCoordinate:(CLLocationCoordinate2D) coordinate withAccuracy:(CLLocationAccuracy) accuracy {
	
	geowikiViewController * gvc = [geowikiViewController sharedInstance];
	
	// get and sort locations
	[self updateLocationsFromServerNearCoordinate:coordinate withAccuracy:accuracy];
	
	if(mode == geoAutoUpdate && ![gvc isLoading]                                                                  ) {
		if([locations count] > 0)
		{
			//[rootViewController
			
		
			// query string
			Location * location = (Location *)[locations objectAtIndex:0];
			NSLog([[location getURL] absoluteString]);
			[gvc loadURL:[location getURL]];
			
			// i guess you can check the url here...
		
			// vibrate when gps fires
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			NSLog(@"MAKE SURE TO TEST FOR CONNECTION!!! - CODE AT BOTTOM OF GEOWIKIAPPDELEGATE.M");
		}
	}
}

-(void) sortLocationsByDistance {
	NSSortDescriptor *locationSorter = [[NSSortDescriptor alloc] initWithKey:@"_distance" ascending:YES];
	[locations sortUsingDescriptors:[NSArray arrayWithObject:locationSorter]];
	[locationSorter release];
}
	

- (void) toggleUpdating {
	if([gpsc isUpdating]) [gpsc stopUpdating];
	else [gpsc startUpdating];
	
}


- (BOOL) isUpdating {
	return [gpsc isUpdating];
}


- (void) setMode: (int) geoWikiMode {
	geowikiViewController * gvc = [geowikiViewController sharedInstance];
	NSString * title;
	BOOL enabled;
	
	if(![self isUpdating]) geoWikiMode = geoUpdateOff;
	
	mode = geoWikiMode;
	switch(geoWikiMode)
	{
		case geoAutoUpdate:
			title = @"Auto Refesh: enabled";
			enabled = YES;
			break;
		case geoLocationBased:
			title = @"Auto Refresh: disabled";
			enabled = YES;
			break;
		case geoUpdateOff:
			title = @"GPS Status: OFF";
			enabled = NO;
			break;
	}
	
	NSLog(@"RAN THE TITLE UPDATE BY MODE CHANGE");
	
	[gvc setToolBarTitle:title enabled:enabled];
}

- (int) getMode {
	return mode;
}

- (void)dealloc {
	[gpsc release];
	//while([locations count] > 0) [[locations lastObject] release];
	[locations release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end


/*

 
 // Use the SystemConfiguration framework to determine if the host that provides
 // the RSS feed is available.
 - (BOOL)isDataSourceAvailable
 {
 static BOOL checkNetwork = YES;
 if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
 checkNetwork = NO;
 
 Boolean success;    
 const char *host_name = "earthquake.usgs.gov";
 
 SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
 SCNetworkReachabilityFlags flags;
 success = SCNetworkReachabilityGetFlags(reachability, &flags);
 _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
 CFRelease(reachability);
 }
 return _isDataSourceAvailable;
 }
 
*/
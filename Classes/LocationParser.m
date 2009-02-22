//
//  LocationParser.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LocationParser.h"

@implementation LocationParser
@synthesize currentLocation;
@synthesize currentPropertyValue;
@synthesize url;

/* Delegate Methods
 http://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=D635F5C417E087A3B9864DAC5D25920C4E9442C9339FA9277951628F0291F620&path=//iphone/library/documentation/Cocoa/Reference/Foundation/Classes/NSXMLParser_Class/NSXMLParser_Class.pdf
– parserDidStartDocument:  delegate method  
– parserDidEndDocument:  delegate method  
– parser:didStartElement:namespaceURI:qualifiedName:attributes:  delegate method  
– parser:didEndElement:namespaceURI:qualifiedName:  delegate method  
– parser:didStartMappingPrefix:toURI:  delegate method  
– parser:didEndMappingPrefix:  delegate method  
– parser:resolveExternalEntityName:systemID:  delegate method  
– parser:parseErrorOccurred:  delegate method  
– parser:validationErrorOccurred:  delegate method  
– parser:foundCharacters:  delegate method  
– parser:foundIgnorableWhitespace:  delegate method  
– parser:foundProcessingInstructionWithTarget:data:  delegate method  
– parser:foundComment:  delegate method  
– parser:foundCDATA:  delegate method  
*/

- (id) init {
	if(self = [super init])
	{
		NSLog(@"CHANGE THE DEFINE FROM TEST_DATA TO GEOWIKI_URL OR THE CORRECT ONE");
		// initialze object
		//currentLocation = nil;
		currentLocation = nil;
		currentPropertyValue = nil;
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TEST_DATA, @"?latitude=40.46&longitude=-86.91"]];
	}
	return self;
}



- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate {
	if(self = [super init])
	{
		NSLog(@"CHANGE THE DEFINE FROM TEST_DATA TO GEOWIKI_URL OR THE CORRECT ONE");
		currentLocation = nil;
		currentPropertyValue = nil;
		//url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TEST_DATA, @"?latitude=40.46&longitude=-86.91"]];
		// remove extra crap
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?latitude=%g&longitude=%g",TEST_DATA, coordinate.latitude, coordinate.longitude]];
	}
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate andAccuracy:(CLLocationAccuracy) accuracy {
	if(self = [super init])
	{
		NSLog(@"CHANGE THE DEFINE FROM TEST_DATA TO GEOWIKI_URL OR THE CORRECT ONE");
		currentLocation = nil;
		currentPropertyValue = nil;
		//url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TEST_DATA, @"?latitude=40.46&longitude=-86.91"]];
		// remove extra crap
		url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?latitude=%g&longitude=%g&accuracy=%g",TEST_DATA, coordinate.latitude, coordinate.longitude, accuracy]];
	}
	return self;
}


- (void) parseLocations {
	// verify url
	
	NSXMLParser * parser = [NSXMLParser alloc];
	[parser setDelegate:self];
	[parser initWithContentsOfURL:url];
	
	if([parser parse])
		NSLog(@"Parsing was successful");
	else
		NSLog(@"Parsing was unsuccessful");
	
	[parser dealloc];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSLog(@"Parsing started");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"Parsing ended");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {

	// why is this done...
	if(qualifiedName) elementName = qualifiedName;

	if([elementName isEqualToString:@"location"])
	{
		self.currentLocation = [[Location alloc] init];
		[[(id)[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addLocation:) withObject:self.currentLocation waitUntilDone:YES];
		//[(geowikiAppDelegate *)[[UIApplication sharedApplication] delegate] addLocation:self.currentLocation];
		
		// from seismicxml
		//[(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addToEarthquakeList:) withObject:self.currentEarthquakeObject waitUntilDone:YES];
        //return;
	}
	
	// prepare the values for setting
	// self.currentPropertyValue = [NSMutableString string];
	else if([elementName isEqualToString:@"title"])
		self.currentPropertyValue = [NSMutableString string];
	else if([elementName isEqualToString:@"url"])
		self.currentPropertyValue = [NSMutableString string];
	else if([elementName isEqualToString:@"latitude"])
		self.currentPropertyValue = [NSMutableString string];
	else if([elementName isEqualToString:@"longitude"])
		self.currentPropertyValue = [NSMutableString string];
	else if([elementName isEqualToString:@"distance"])
		self.currentPropertyValue = [NSMutableString string];
	else currentPropertyValue = nil;
	
	// handle error here

	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	
	if(qName) elementName = qName;
	
	// set the values of the location
	if([elementName isEqualToString:@"title"])
		[self.currentLocation setTitle:self.currentPropertyValue];
	else if([elementName isEqualToString:@"url"])
		[self.currentLocation setURL:[NSURL URLWithString:self.currentPropertyValue]];
	else if([elementName isEqualToString:@"latitude"])
		[self.currentLocation setLatitude:[self.currentPropertyValue doubleValue]];
	else if([elementName isEqualToString:@"longitude"])
		[self.currentLocation setLongitude:[self.currentPropertyValue doubleValue]];
	else if([elementName isEqualToString:@"distance"])
		[self.currentLocation setDistance:[self.currentPropertyValue doubleValue]];
	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	// handle parsing error
	NSLog(@"parse error: parsing aborted");
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
	// handle validation error
	NSLog(@"validation error: parsing aborted");
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentPropertyValue) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentPropertyValue appendString:string];
    }
}

- (void) dealloc
{
	[url release];
	[currentPropertyValue release];
	[currentLocation release];
	[super dealloc];
}

@end

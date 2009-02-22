//
//  RootViewController.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "geowikiAppDelegate.h"


@implementation RootViewController
@synthesize tableView = locationView;
@synthesize toolbar = infobar;
@synthesize gpstoggle;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder])
	{
		self.title = @"Locations";
		self.tableView.delegate = self;
	}
	return self;
}


- (IBAction) showInfo:(id)sender {
	AboutViewController * avc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
	[[self navigationController] presentModalViewController:avc animated:YES];
	[avc release];
	
}

- (IBAction) toggleUpdating:(id) sender {
	geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelegate toggleUpdating];

	// use sender?
	if([appDelegate isUpdating]) {
		NSLog(@"I think it would be better to have it in manual mode at this point but for now I will just push the webview onto the stack again");
		[gpstoggle setTitle:@"Updating: enabled"];
		[appDelegate setMode:geoAutoUpdate];
		[[geowikiViewController sharedInstance] showLoadingScreen];
		[[self navigationController] pushViewController:[geowikiViewController sharedInstance] animated:YES];
	}
	else 
	{
		[appDelegate setMode:geoUpdateOff];
		[gpstoggle setTitle:@"Updating: disabled"];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
    return [appDelegate numberOfLocations];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LocationCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
    
	NSString * locationTitle = [(Location *)[appDelegate locationForCell:indexPath.row] getTitle];
	cell.text = [NSString stringWithFormat:@"%@ %g", locationTitle, [(Location *)[appDelegate locationForCell:indexPath.row] getDistance]];
    // Set up the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic -- create and push a new view controller
	
	geowikiViewController * viewController = [geowikiViewController sharedInstance];
	geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelegate setMode:geoLocationBased];
	[viewController loadURL:[(Location *)[appDelegate locationForCell:indexPath.row] getURL]];
	[[self navigationController] pushViewController:viewController animated:YES];
	
	/*
	geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	geowikiViewController * gvc = [[geowikiViewController alloc] initWithLocation:[appDelegate locationForCell:indexPath.row] withStatus:[appDelegate getMode]];
	[[self navigationController] pushViewController:gvc animated:YES];
	[gvc release];
	*/
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to add the Edit button to the navigation bar.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


/*
// Override to support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end


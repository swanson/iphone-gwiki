#import "geowikiViewController.h"
#import "geowikiAppDelegate.h"

@implementation geowikiViewController

@synthesize activityIndicator, webview, loadingpage, toolbar, modeToggle;

/* initialize with interface builder */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		// consider loading the name of the location
		NSLog(@"CONSIDER NAME OF LOCATION FOR TITLE");
		[[self view] bringSubviewToFront:webview];
		[[self view] bringSubviewToFront:toolbar];
		[webview setScalesPageToFit:YES];
		self.title = @"GWiki Location";
		loading = NO;
	}
	return self;
}

- (void) setToolBarTitle:(NSString *) title enabled:(BOOL)enabled {
	[modeToggle setTitle:title];
	[modeToggle setEnabled:enabled];
}

- (IBAction)setAutoRefresh:(id)sender {
	geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	if([appDelegate getMode] == geoLocationBased)
	{
		[appDelegate setMode:geoAutoUpdate];
		//[sender setTitle:@"Auto Refresh: enabled"];
	}
	else if([appDelegate getMode] == geoAutoUpdate)
	{
		[appDelegate setMode:geoLocationBased];
		//[sender setTitle:@"Auto Refresh: disabled"];
		/* optional popping of view controller */
		//[[self navigationController] popViewControllerAnimated:YES];
	}
}

- (BOOL) isLoading {
	return loading;
}

- (IBAction) showInfo:(id)sender {
	NSLog(@"show info");
	AboutViewController * avc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
	[[self navigationController] presentModalViewController:avc animated:YES];
	[avc release];
}


/* load file */
- (void) loadFile:(NSString *) path {
	NSURL * url = [NSURL fileURLWithPath:path];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	//[(UIWebView *)[self view] loadRequest:request];
	[webview loadRequest:request];
}

/* load resource file */
- (void) loadResourceFile:(NSString *) file {
	NSString * path = [[NSBundle mainBundle] resourcePath];
	path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",file]];
	NSURL * url = [NSURL fileURLWithPath:path];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[webview loadRequest:request];
}

/* load page method */
- (void) loadPage:(NSString *) page {
	NSURL * url = [NSURL URLWithString:page];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[webview loadRequest:request];
}

/* load url */
-(void) loadURL:(NSURL *) url {
	// in case webview is currently loading a page, not sure how it handles multiple requests while not finishing first
	[webview stopLoading];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSLog([url absoluteString]);
	[webview loadRequest:request];
	
}



- (void) loadURL:(NSURL *) url withQueryString:(NSString *)qstring {
	url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",[url absoluteURL], qstring]];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[webview loadRequest:request];
}


- (void) loadPage:(NSString *)page withQueryString:(NSString *) queryString {
	NSString * pageWithQueryString = [NSString stringWithFormat:@"%@%@", page, queryString];
	[self loadPage:pageWithQueryString];
}



/* Touch Event for Normal View */
// loading page touches...
/*
- (void) touchesBegan: (NSSet *) touches withEvent:(UIEvent *)event {
	//[[self navigationController] popViewControllerAnimated:YES];
	//[[self loadingpage] setHidden:YES];
	//[self hideLoadingScreen];
}
*/


/* UIWebViewDelegate Methods */
- (void)webViewDidStartLoad:(UIWebView *)webView
{	
	[[self navigationItem] setHidesBackButton:YES];
	loading = YES;
	// possibly load empty page before loading actual page
	/*
	//[loadingpage setHidden:NO];
	[[self view] bringSubviewToFront:loadingpage];
	[[self view] bringSubviewToFront:toolbar];
	[activityIndicator startAnimating];
	*/
	
	
	//[[self loadingpage] setHidden:NO];
	geowikiAppDelegate * appDelegate = (geowikiAppDelegate *) [[UIApplication sharedApplication] delegate];
	if([appDelegate getMode] == geoAutoUpdate)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];			
		[loadingpage setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
		[[self view] bringSubviewToFront:loadingpage];
		[[self view] bringSubviewToFront:toolbar];
		[activityIndicator startAnimating];
		[UIView commitAnimations];
	}
	else
	{
		[loadingpage setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
		[[self view] bringSubviewToFront:loadingpage];
		[[self view] bringSubviewToFront:toolbar];
		[activityIndicator startAnimating];
	}

}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{	
	loading = NO;
	[[self navigationItem] setHidesBackButton:NO];
	/*
	[[self activityIndicator] stopAnimating];
	[[self view] bringSubviewToFront:webview];
	[[self view] bringSubviewToFront:toolbar];
	*/
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	[loadingpage setBackgroundColor:[UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha: 0.0f]];
	[NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(hideLoadingScreen) userInfo:nil repeats:NO];
	[UIView commitAnimations];
	
}



// failure - need default page to load or tell that the server is not connected
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self loadResourceFile:@"error.html"];
	// consider handling each error by code
	// [error code]
}


// animation helper
- (void) hideLoadingScreen
{	
	
	[[self activityIndicator] stopAnimating];
	[[self view] bringSubviewToFront:webview];
	[[self view] bringSubviewToFront:toolbar];
	
	//[[self loadingpage] setHidden:YES];
}


- (void) showLoadingScreen {
	[loadingpage setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
	[activityIndicator startAnimating];
	[[self view] bringSubviewToFront:loadingpage];
	[[self view] bringSubviewToFront:toolbar];
}


/******** SINGLETON CLASS METHODS ***********/
static geowikiViewController * sharedController;
+ (geowikiViewController *) sharedInstance {
	// not so sure we have to worry about threads here, but...
	//@synchronized(self)
	{
		if(sharedController == nil) 
			sharedController = [[self alloc] initWithNibName:@"geowikiViewController" bundle:[NSBundle mainBundle]];
		NSLog(@"init with nib name");
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

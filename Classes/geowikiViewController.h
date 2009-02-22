#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Location.h"

//#import "RootViewController.h"
//#import "geowikiAppDelegate.h"

@interface geowikiViewController : UIViewController {
	
	// Implement these to not reload the page because its expensive
	/*
	NSString * lastURL;
	BOOL lastURLfailed;
	*/
	
	
	IBOutlet UIWebView * webview;
	IBOutlet UIView * loadingpage;
	IBOutlet UIActivityIndicatorView * activityIndicator;
	IBOutlet UIToolbar * toolbar;
	IBOutlet UIBarButtonItem * modeToggle;
	
	BOOL loading;
}

/* Interface Builder outlets */
@property(nonatomic, retain) IBOutlet UIWebView * webview;
@property(nonatomic, retain) IBOutlet UIView * loadingpage;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicator;
@property(nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * modeToggle;

/* singleton instance */
+ (geowikiViewController *) sharedInstance;



/* webview methods */
- (void)loadFile:(NSString *) path;
- (void)loadResourceFile:(NSString *) file;
- (void)loadPage:(NSString *) page;
- (void)loadURL:(NSURL *) url;
- (void)loadURL:(NSURL *) url withQueryString:(NSString *)qstring;
- (void)loadPage:(NSString *)page withQueryString:(NSString *) queryString;

/* UI Methods */
- (void) showLoadingScreen;
- (void) hideLoadingScreen;
- (void) setToolBarTitle:(NSString *) title enabled:(BOOL)enabled;
- (BOOL) isLoading;

/* IBAction methods */
- (IBAction)setAutoRefresh:(id)sender;
- (IBAction)showInfo:(id)sender;

@end

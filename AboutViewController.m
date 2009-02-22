#import "AboutViewController.h"

@implementation AboutViewController

/* touch began */
/* touch ended */
- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	NSLog(@"TOUCHED");
	[[self navigationController] dismissModalViewControllerAnimated:YES];
}

@end

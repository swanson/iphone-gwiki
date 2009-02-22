//
//  RootViewController.h
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCell.h"
#import "geowikiViewController.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UIToolbar * infobar;
	IBOutlet UITableView * locationView;
	UIBarButtonItem * gpstoggle;
}

@property (nonatomic, readonly) UITableView * tableView;
@property (nonatomic, readonly) UIToolbar * toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * gpstoggle;

- (IBAction) showInfo:(id)sender;
- (IBAction) toggleUpdating:(id) sender;

@end

//
//  LocationCell.m
//  geowiki
//
//  Created by Dave Rahmany on 11/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LocationCell.h"


@implementation LocationCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		// need to make custom cell...
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end

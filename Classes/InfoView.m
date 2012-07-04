//
//  InfoView.m
//  ARTest
//
//  Created by Sébastien Orban on 5/10/11.
//  Copyright 2011 Sébastien Orban. All rights reserved.
//

#import "InfoView.h"


@implementation InfoView
@synthesize description;

-(void) willMoveToWindow:(UIWindow *)newWindow {
}

-(IBAction) memberButton:(id) sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"member", nil)]];
}
-(IBAction) giftButton:(id) sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"gift", nil)]];
}

-(IBAction) closeButton:(id) sender {
	[self removeFromSuperview];
}

@end

//
//  ARViewButton.m
//  AR
//
//  Created by Sébastien Orban on 29/09/11.
//  Copyright 2011 Sébastien Orban. All rights reserved.
//

#import "ARViewButton.h"

#define BOX_WIDTH 220
#define TEXT_WIDTH 200
#define BOX_HEIGHT 105

@implementation ARViewButton

@synthesize content, distance, title;


-(id) initForCoordinate: (ARCoordinate *) coordinate {
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	if (self = [super initWithFrame:theFrame]) {
		UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT)];
		buttonImage.image = [UIImage imageNamed:@"bulle_noir.png"];
		
		
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(5, 5, TEXT_WIDTH, 20.0)];
		[titleLabel setBackgroundColor: [UIColor clearColor]];
		[titleLabel setTextColor:		[UIColor whiteColor]];
		[titleLabel setTextAlignment:	UITextAlignmentCenter];
		[titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		titleLabel.font = [UIFont boldSystemFontOfSize:16];
		[titleLabel setNumberOfLines:1];
		[titleLabel setText:[coordinate title]];
		
		UILabel *contentLabel	= [[UILabel alloc] initWithFrame:CGRectMake(5, 25, TEXT_WIDTH, 40.0)];
		[contentLabel setBackgroundColor: [UIColor clearColor]];
		[contentLabel setTextColor:		[UIColor whiteColor]];
		[contentLabel setTextAlignment:	UITextAlignmentCenter];
		contentLabel.font = [UIFont systemFontOfSize:16];
		[contentLabel setLineBreakMode:UILineBreakModeWordWrap];
		[contentLabel setNumberOfLines:2];
		
		content = [coordinate subtitle];
		title = [coordinate title];
		
		if ([[coordinate subtitle] length] <= 100)
			[contentLabel setText:			[coordinate subtitle]];
		else 
			[contentLabel setText:[[coordinate subtitle] substringWithRange:NSMakeRange(0, 100)]];
		 
		distanceLabel	= [[UILabel alloc] initWithFrame:CGRectMake(5, 65, TEXT_WIDTH, 20.0)];
		[distanceLabel setBackgroundColor: [UIColor clearColor]];
		[distanceLabel setTextColor:		[UIColor whiteColor]];
		[distanceLabel setTextAlignment:	UITextAlignmentCenter];
		distanceLabel.font = [UIFont boldSystemFontOfSize:16];
		[distanceLabel setLineBreakMode:UILineBreakModeWordWrap];
		[distanceLabel setNumberOfLines:1];
		distance = [NSString stringWithFormat:@"%f km", [coordinate radialDistance]];
		[distanceLabel setText:distance];
		
		[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:buttonImage];
		[self addSubview:titleLabel];
		[self addSubview:contentLabel];
		[self addSubview:distanceLabel];
		
	}
	return self;
}
-(void) setDistance:(NSString *) dist {
	distance = dist;
	distanceLabel.text = dist;
}

- (void)buttonPressed: (id) sender {
	// TODO: Could toggle a button state and/or image
}

@end

//
//  CoordinateView.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Agilite Software. All rights reserved.
//

#import "CoordinateView.h"
#import "ARCoordinate.h"

#define BOX_WIDTH 240
#define TEXT_WIDTH 200
#define BOX_HEIGHT 90

@implementation CoordinateView


- (id)initForCoordinate:(ARCoordinate *)coordinate {
    	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	if (self = [super initWithFrame:theFrame]) {
		
		UIButton * testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TEXT_WIDTH, BOX_HEIGHT)];
		testButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		testButton.titleLabel.textAlignment = UITextAlignmentCenter;
		[[testButton titleLabel] setNumberOfLines:4];
		if ([[coordinate title] length] <= 100)
			[testButton setTitle:[coordinate title] forState:UIControlStateNormal];
		else 
			[testButton setTitle:[[coordinate title] substringWithRange:NSMakeRange(0, 100)] forState:UIControlStateNormal];
			 
		[testButton setBackgroundImage:[UIImage imageNamed:@"bulle_blanc.png"] forState:UIControlStateNormal];
		[testButton setEnabled:YES];
		[testButton addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
		[testButton setUserInteractionEnabled:YES];
		/*
		UIImageView * background = [[UIImageView alloc] initWithFrame:theFrame];
		[background setImage: [UIImage imageNamed:@"bulle_blanc.png"]];
		[background setAutoresizesSubviews:YES];
		[background setContentMode:UIViewContentModeScaleAspectFill];
		
		
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(20, 0, TEXT_WIDTH, 80.0)];
		//UILabel *titleLabel	= [[UILabel alloc] init];
		
		[titleLabel setBackgroundColor: [UIColor clearColor]];
		[titleLabel setTextColor:		[UIColor blackColor]];
		[titleLabel setTextAlignment:	UITextAlignmentCenter];
		[titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[titleLabel setNumberOfLines:4];
		if ([[coordinate title] length] <= 100)
			[titleLabel setText:			[coordinate title]];
		else 
			[titleLabel setText:[[coordinate title] substringWithRange:NSMakeRange(0, 100)]];
		//[titleLabel setText:			[coordinate title]];
		//[titleLabel sizeToFit];
		//[titleLabel setFrame:	CGRectMake(TEXT_WIDTH / 2.0 - [titleLabel bounds].size.width / 2.0 - 4.0, 0, [titleLabel bounds].size.width + 8.0, [titleLabel bounds].size.height + 8.0)];
		
		UIButton * testBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
		[testBtn setTitle:@"test" forState:UIControlStateNormal];
		[testBtn setEnabled:YES];
		[testBtn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside ];*/

		
		//[self addSubview:background];
		//[self addSubview:titleLabel];
		//[self sendSubviewToBack:titleLabel];
		//[self sendSubviewToBack:background];
		//[self addSubview:pointView];
		//[self addSubview:testBtn];
		[self addSubview:testButton];
		[self setBackgroundColor:[UIColor clearColor]];
		//[pointView release];
	}
	
    return self;
}

- (void)testClick:(id)sender {
	NSLog(@"click");
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}




@end

//
//  ARViewButton.h
//  AR
//
//  Created by Sébastien Orban on 29/09/10.
//  Copyright 2010 WiO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoordinateView.h"
#import "ARCoordinate.h"


@interface ARViewButton : UIControl {
	NSString * content;
	NSString * title;
	NSString * distance;
	UILabel * distanceLabel;
}

@property (nonatomic) NSString * content;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * distance;

-(id) initForCoordinate: (ARCoordinate *) coordinate;
- (void)buttonPressed: (id) sender;
-(void) setDistance:(NSString *) dist;


@end

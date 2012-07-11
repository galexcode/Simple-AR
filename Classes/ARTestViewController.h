//
//  ARTestViewController.h
//  ARTest
//
//  Created by Sébastien Orban on 1/10/10.
//  Copyright 2010 WiO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "GEOLocations.h"
#import "CoordinateView.h"
#import "ARViewButton.h"

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1.25
#define CAMERA_TRANSFORM_Y 1.25

// iPhone screen dimensions:
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@interface ARTestViewController : UIViewController {
	OverlayView	* overlay;
}

@property (nonatomic) OverlayView *overlay;

-(void) reinit;

@end


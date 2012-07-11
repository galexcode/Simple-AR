//
//  ARTestViewController.m
//  ARTest
//
//  Created by Sébastien Orban on 1/10/11.
//  Copyright 2011 Sébastien Orban. All rights reserved.
//

#import "ARTestViewController.h"

@implementation ARTestViewController
@synthesize overlay;

- (void) viewDidAppear:(BOOL)animated {
	if (overlay == nil) {
		overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
		
		[overlay setDebugMode:NO];
		[overlay setScaleViewsBasedOnDistance:NO];
		[overlay setMinimumScaleFactor:0.4];
		[overlay setRotateViewsBasedOnPerspective:NO];
	}
	
	
	GEOLocations* locations = [[GEOLocations alloc] init];	
	overlay.noInfo = NO;
	if ([[locations getLocations] count] > 0) {
		for (ARCoordinate *coordinate in [locations getLocations]) {
			ARViewButton * cv = [[ARViewButton alloc] initForCoordinate:coordinate];
			[overlay addCoordinate:coordinate augmentedView:cv animated:NO];
		}
	}
	else {
		overlay.noInfo = YES;
	}

	
	
	
	// Create a new image picker instance:
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	
	// Set the image picker source:
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	// Hide the controls:
	picker.showsCameraControls = NO;
	picker.navigationBarHidden = YES;
	
	// Make camera view full screen:
	picker.wantsFullScreenLayout = YES;
	picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, 1.25f, 1.25f);
	
	// Insert the overlay:
	picker.cameraOverlayView = overlay;
	
	// Show the picker:
	[self presentModalViewController:picker animated:YES];	
	//[picker release];
	[super viewDidAppear:YES];
}

-(void) reinit {
	//overlay.locationManager;
	
	for (ARViewButton *item in overlay.coordinateViews) {
		[item removeFromSuperview];
	}
	
	[overlay.coordinates removeAllObjects];
	[overlay.coordinateViews removeAllObjects];
	[overlay.coordinatesYVal removeAllObjects];
	
	GEOLocations* locations = [[GEOLocations alloc] init];	
	overlay.noInfo = NO;
	if ([[locations getLocations] count] > 0) {
		for (ARCoordinate *coordinate in [locations getLocations]) {
			ARViewButton * cv = [[ARViewButton alloc] initForCoordinate:coordinate];
			[overlay addCoordinate:coordinate augmentedView:cv animated:NO];
		}
	}
	else {
		overlay.noInfo = YES;
	}
	
	[overlay reinit];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end

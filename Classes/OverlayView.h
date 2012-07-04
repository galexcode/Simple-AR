//
//  OverlayView.h
//  OverlayViewTester
//
//  Created by Sébastien Orban on 10-01-10.
//  Copyright 2010 WiO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "ARViewButton.h"
#import "ARCoordinate.h"
#import "ARGeoCoordinate.h"
#import "InfoView.h"

#define kFilteringFactor 0.05
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(x) ((x) * 180.0/M_PI)

@class ARCoordinate;

@interface OverlayView : UIView <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	BOOL scaleViewsBasedOnDistance;
	BOOL rotateViewsBasedOnPerspective;
	BOOL noInfo;
	BOOL reInit;
	
	double maximumScaleDistance;
	double minimumScaleFactor;
	double maximumRotationAngle;
	
	float povRange;
	
	ARCoordinate		*centerCoordinate;
	CLLocationManager	*locationManager;
	UIDeviceOrientation currentOrientation;
	
	UIAccelerometer		*accelerometerManager;
	CLLocation			*centerLocation;
	UILabel				*debugView;
	
	InfoView			* infoView;
	UIButton * infoButton;
	UIActivityIndicatorView * waitSignal;
	UILabel				* noConnexionLabel;
	
	double				latestHeading;
	double				degreeRange;
	float				viewAngle;
	BOOL				debugMode;
	
	NSMutableArray		*coordinates;
	NSMutableArray		*coordinateViews;
	NSMutableArray		*coordinatesYVal;
}

@property BOOL scaleViewsBasedOnDistance;
@property BOOL rotateViewsBasedOnPerspective;
@property BOOL debugMode;
@property BOOL noInfo;

@property double maximumScaleDistance;
@property double minimumScaleFactor;
@property double maximumRotationAngle;
@property double degreeRange;

@property (nonatomic, retain) UIAccelerometer	*accelerometerManager;
@property (nonatomic, retain) CLLocationManager	*locationManager;
@property (nonatomic, retain) ARCoordinate		*centerCoordinate;
@property (nonatomic, retain) CLLocation		*centerLocation;
@property UIDeviceOrientation	currentOrientation;
@property (nonatomic, retain) NSMutableArray *coordinates;
@property (nonatomic, retain) NSMutableArray *coordinateViews;
@property (nonatomic, retain) NSMutableArray *coordinatesYVal;


- (void) setupDebugPostion;
- (void) updateLocations;
-(void) reinit;

// Adding coordinates to the underlying data model.
//- (void)addCoordinate:(ARCoordinate *)coordinate augmentedView:(UIView *)agView animated:(BOOL)animated ;
- (void)addCoordinate:(ARCoordinate *)coordinate augmentedView:(ARViewButton *)agView animated:(BOOL)animated;

// Removing coordinates
- (void)removeCoordinate:(ARCoordinate *)coordinate;
- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;
- (void)removeCoordinates:(NSArray *)coordinateArray;

@end

@interface OverlayView (Private)
- (void) updateCenterCoordinate;
- (void) startListening;
- (double) findDeltaOfRadianCenter:(double*)centerAzimuth coordinateAzimuth:(double)pointAzimuth betweenNorth:(BOOL*) isBetweenNorth;
- (CGPoint) pointInView:(UIView *)realityView withView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate;
- (BOOL) viewportContainsView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate;
@end

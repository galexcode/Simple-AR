//
//  OverlayView.m
//  OverlayViewTester
//
//  Created by Jason Job on 09-12-10.
//  Way too much rewritten by S. Orban 29/09/11
//


#import "OverlayView.h"



@implementation OverlayView

@synthesize locationManager;
@synthesize accelerometerManager;
@synthesize centerCoordinate;
@synthesize scaleViewsBasedOnDistance;
@synthesize rotateViewsBasedOnPerspective;
@synthesize maximumScaleDistance;
@synthesize minimumScaleFactor;
@synthesize maximumRotationAngle;
@synthesize centerLocation;
@synthesize coordinates;
@synthesize coordinateViews;
@synthesize currentOrientation;
@synthesize degreeRange;
@synthesize noInfo;
@synthesize coordinatesYVal;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		noInfo = NO;
		reInit = NO;
		// Point of View degree range modifier - base 12
		povRange = 8;
		
		coordinates		= [[NSMutableArray alloc] init];
		coordinateViews	= [[NSMutableArray alloc] init];
		coordinatesYVal = [[NSMutableArray alloc] init];
		latestHeading	= -1.0f;
		debugView		= nil;
		
		[self setDebugMode:NO];
		[self setMaximumScaleDistance: 0.0];
		[self setMinimumScaleFactor: 1.0];
		[self setScaleViewsBasedOnDistance: NO];
		[self setRotateViewsBasedOnPerspective: NO];
		[self setMaximumRotationAngle: M_PI / 6.0];
		[self setDegreeRange:[self bounds].size.width / povRange];
		
		CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:37.41711 longitude:-122.02528];
		
		[self setCenterLocation: newCenter];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object:nil];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];	
		
		[self startListening];
		
		infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[infoButton setBackgroundImage:[UIImage imageNamed:@"buille_jaune.png"] forState:UIControlStateNormal];
		[infoButton setFrame:CGRectMake(0, 269, 186, 51)];
		[infoButton setTitle:NSLocalizedString(@"Whatever", nil) forState:UIControlStateNormal];
		[infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[infoButton setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
		[infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:infoButton];
		
		waitSignal = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		waitSignal.center = CGPointMake(240, 160);
		[waitSignal startAnimating];
		[self addSubview:waitSignal];
		
		
    }
    return self;
}

-(void) reinit {
	reInit = YES;
	
	CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:37.41711 longitude:-122.02528];

	[self setCenterLocation: newCenter];
	
	[self startListening];
	
	waitSignal = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	waitSignal.center = CGPointMake(240, 160);
	[waitSignal startAnimating];
	[self addSubview:waitSignal];
}

-(void) infoButtonClick:(id) sender {
	infoView = [[[NSBundle mainBundle] loadNibNamed:@"infoView" owner:self options:nil] objectAtIndex:0];
	[infoView setFrame:CGRectMake(0, 0, 480, 320)];
	[self addSubview:infoView];
	[self bringSubviewToFront:infoView];
	
}

- (void)startListening {
	// start our heading readings and our accelerometer readings.
	if (![self locationManager]) {
		[self setLocationManager: [[CLLocationManager alloc] init]];
		[[self locationManager] setHeadingFilter: kCLHeadingFilterNone];
		[[self locationManager] setDesiredAccuracy: kCLLocationAccuracyBest];
		[[self locationManager] startUpdatingHeading];
		[[self locationManager] startUpdatingLocation];
		[[self locationManager] setDelegate: self];
	}
	
	if (![self accelerometerManager]) {
		[self setAccelerometerManager: [UIAccelerometer sharedAccelerometer]];
		// base updateInterval : 0.25
		[[self accelerometerManager] setUpdateInterval: 2];
		[[self accelerometerManager] setDelegate: self];
	}
	
	if (![self centerCoordinate]) 
		[self setCenterCoordinate:[ARCoordinate coordinateWithRadialDistance:1.0 inclination:0 azimuth:0]];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	latestHeading = degreesToRadian(newHeading.magneticHeading);
	[self updateCenterCoordinate];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (oldLocation == nil || reInit == YES)
		[self setCenterLocation:newLocation];
	if (noInfo == YES) {
		noConnexionLabel = [[UILabel alloc] init];
		noConnexionLabel.text = @"No connexion";
		noConnexionLabel.frame = CGRectMake(0, 0, 160, 30);
		noConnexionLabel.textAlignment = UITextAlignmentCenter;
		noConnexionLabel.center = CGPointMake(240, 160);
		noConnexionLabel.tag = 77;
		[self addSubview:noConnexionLabel];
	}
	else {
		[noConnexionLabel removeFromSuperview];
	}

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
}

-(void) setupDebugPostion {
	
	if ([self debugMode]) {
		[debugView sizeToFit];
		CGRect displayRect = [self bounds];
		
		[debugView setFrame:CGRectMake(0, displayRect.size.height - [debugView bounds].size.height,  displayRect.size.width, [debugView bounds].size.height)];
	}
}

- (void)updateCenterCoordinate {
	
	double adjustment = 0;
	
	if (currentOrientation == UIDeviceOrientationLandscapeLeft)
		adjustment = degreesToRadian(270); 
	else if (currentOrientation == UIDeviceOrientationLandscapeRight)
		adjustment = degreesToRadian(90);
	else if (currentOrientation == UIDeviceOrientationPortraitUpsideDown)
		adjustment = degreesToRadian(180);
	
	[[self centerCoordinate] setAzimuth: latestHeading - adjustment];
	[self updateLocations];
	[waitSignal removeFromSuperview];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	switch (currentOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			viewAngle = atan2(acceleration.x, acceleration.z);
			[infoButton setFrame:CGRectMake(0, 269, 186, 51)];
			break;
		case UIDeviceOrientationLandscapeRight:
			viewAngle = atan2(-acceleration.x, acceleration.z);
			break;
		case UIDeviceOrientationPortrait:
			viewAngle = atan2(acceleration.y, acceleration.z);
			[infoButton setFrame:CGRectMake(0, 409, 186, 51)];
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			viewAngle = atan2(-acceleration.y, acceleration.z);
			break;	
		default:
			break;
	}
	
	[self updateCenterCoordinate];
}

- (void)setCenterLocation:(CLLocation *)newLocation {
	centerLocation = newLocation;
	int index = 0;
	
	for (ARGeoCoordinate *geoLocation in [self coordinates]) {
		
		if ([geoLocation isKindOfClass:[ARGeoCoordinate class]]) {
			[geoLocation calibrateUsingOrigin:centerLocation];
			ARViewButton * temp = (ARViewButton *)[coordinateViews objectAtIndex:index];
			temp.distance = [NSString stringWithFormat:@"%.2f km", geoLocation.radialDistance / 1000];
			if ([geoLocation radialDistance] > [self maximumScaleDistance]) 
				[self setMaximumScaleDistance:[geoLocation radialDistance]];
		}
		index++;
	}
}

- (void)addCoordinate:(ARCoordinate *)coordinate augmentedView:(ARViewButton *)agView animated:(BOOL)animated {
	
	[coordinates addObject:coordinate];
	
	// change Y val randomly
	NSNumber  * var = [[NSNumber alloc] initWithInt:(arc4random() % 180) - 90];
	[coordinatesYVal addObject:var];
	
	if ([coordinate radialDistance] > [self maximumScaleDistance]) 
		[self setMaximumScaleDistance: [coordinate radialDistance]];
	
	[coordinateViews addObject:agView];
}


- (void)removeCoordinate:(ARCoordinate *)coordinate {
	[self removeCoordinate:coordinate animated:YES];
}

- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
	[coordinates removeObject:coordinate];
}

- (void)removeCoordinates:(NSArray *)coordinateArray {	
	
	for (ARCoordinate *coordinateToRemove in coordinateArray) {
		NSUInteger indexToRemove = [coordinates indexOfObject:coordinateToRemove];
		
		//TODO: Error checking in here.
		[coordinates	 removeObjectAtIndex:indexToRemove];
		[coordinateViews removeObjectAtIndex:indexToRemove];
	}
}

-(double) findDeltaOfRadianCenter:(double*)centerAzimuth coordinateAzimuth:(double)pointAzimuth betweenNorth:(BOOL*) isBetweenNorth {
	
	if (*centerAzimuth < 0.0) 
		*centerAzimuth = (M_PI * 2.0) + *centerAzimuth;
	
	if (*centerAzimuth > (M_PI * 2.0)) 
		*centerAzimuth = *centerAzimuth - (M_PI * 2.0);
	
	double deltaAzimith = ABS(pointAzimuth - *centerAzimuth);
	*isBetweenNorth		= NO;
	
	// If values are on either side of the Azimuth of North we need to adjust it.  Only check the degree range
	if (*centerAzimuth < degreesToRadian([self degreeRange]) && pointAzimuth > degreesToRadian(360-[self degreeRange])) {
		deltaAzimith	= (*centerAzimuth + ((M_PI * 2.0) - pointAzimuth));
		*isBetweenNorth = YES;
	}
	else if (pointAzimuth < degreesToRadian([self degreeRange]) && *centerAzimuth > degreesToRadian(360-[self degreeRange])) {
		deltaAzimith	= (pointAzimuth + ((M_PI * 2.0) - *centerAzimuth));
		*isBetweenNorth = YES;
	}
	
	return deltaAzimith;
}
- (BOOL)viewportContainsView:(UIView *)viewToDraw  forCoordinate:(ARCoordinate *)coordinate {
	
	double currentAzimuth = [[self centerCoordinate] azimuth];
	double pointAzimuth	  = [coordinate azimuth];
	BOOL isBetweenNorth	  = NO;
	double deltaAzimith	  = [self findDeltaOfRadianCenter: &currentAzimuth coordinateAzimuth:pointAzimuth betweenNorth:&isBetweenNorth];
	BOOL result			  = NO;
	
	if (deltaAzimith <= degreesToRadian([self degreeRange]))
		result = YES;
	
	return result;
}

- (void)updateLocations {
	
	if (!coordinateViews || [coordinateViews count] == 0) 
		return;
	if([self.subviews containsObject:infoView])
		return;
	[debugView setText: [NSString stringWithFormat:@"%.3f %.3f ", -radianToDegrees(viewAngle), [[self centerCoordinate] azimuth]]];
	
	int index			= 0;
	int totalDisplayed	= 0;
	for (ARCoordinate *item in coordinates) {
		ARViewButton * viewToDraw = [coordinateViews objectAtIndex:index];
		
		if ([self viewportContainsView:viewToDraw forCoordinate:item]) {
			
			//[viewToDraw addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
			
			CGPoint loc = [self pointInView:self withView:viewToDraw forCoordinate:item];
			CGFloat scaleFactor = 1.0;
			
			if ([self scaleViewsBasedOnDistance]) 
				scaleFactor = 1.0 - [self minimumScaleFactor] * ([item radialDistance] / [self maximumScaleDistance]);
			
			float width	 = [viewToDraw bounds].size.width  * scaleFactor;
			float height = [viewToDraw bounds].size.height * scaleFactor;
			
			//[viewToDraw setFrame:CGRectMake(loc.x - width / 2.0, loc.y - (height / 2.0) + [[coordinatesYVal objectAtIndex:index] intValue], width, height)];
			[viewToDraw setFrame:CGRectMake(loc.x - width / 2.0, loc.y - (height / 2.0) + [[coordinatesYVal objectAtIndex:index] intValue], 220, 105)];
			
			
			totalDisplayed++;
			
			CATransform3D transform = CATransform3DIdentity;
			
			// Set the scale if it needs it. Scale the perspective transform if we have one.
			if ([self scaleViewsBasedOnDistance]) 
				transform = CATransform3DScale(transform, scaleFactor, scaleFactor, scaleFactor);
			
			if ([self rotateViewsBasedOnPerspective]) {
				transform.m34 = 1.0 / 300.0;
				
				double itemAzimuth		= [item azimuth];
				double centerAzimuth	= [[self centerCoordinate] azimuth];
				
				if (itemAzimuth - centerAzimuth > M_PI) 
					centerAzimuth += 2 * M_PI;
				
				if (itemAzimuth - centerAzimuth < -M_PI) 
					itemAzimuth  += 2 * M_PI;
				
				double angleDifference	= itemAzimuth - centerAzimuth;
				transform				= CATransform3DRotate(transform, [self maximumRotationAngle] * angleDifference / 0.3696f , 0, 1, 0);
			}
			
			[[viewToDraw layer] setTransform:transform];
			
			//if we don't have a superview, set it up.
			if (!([viewToDraw superview])) {
				// Add a target action for the button:
				[viewToDraw addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:viewToDraw];
				
				//[self addSubview:viewToDraw];
				//[[self displayView] sendSubviewToBack:viewToDraw];
			}
		} 
		else 
			[viewToDraw removeFromSuperview];
		
		index++;
	}
}

- (void)testClick:(id)sender {
	ARViewButton * temp = (ARViewButton *) sender;
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:temp.title
									   message:temp.content
									  delegate:self
							 cancelButtonTitle:@"OK"
							 otherButtonTitles:nil];
	[alert show];
}

- (CGPoint)pointInView:(UIView *)realityView withView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate {	
	
	CGPoint point;
	CGRect realityBounds	= [realityView bounds];
	double currentAzimuth	= [[self centerCoordinate] azimuth];
	double pointAzimuth		= [coordinate azimuth];
	BOOL isBetweenNorth		= NO;
	double deltaAzimith		= [self findDeltaOfRadianCenter: &currentAzimuth coordinateAzimuth:pointAzimuth betweenNorth:&isBetweenNorth];
	
	if ((pointAzimuth > currentAzimuth && !isBetweenNorth) || (currentAzimuth > degreesToRadian(360-[self degreeRange]) && pointAzimuth < degreesToRadian([self degreeRange])))
		point.x = (realityBounds.size.width / 2) + ((deltaAzimith / degreesToRadian(1)) * povRange);  // Right side of Azimuth
	else
		point.x = (realityBounds.size.width / 2) - ((deltaAzimith / degreesToRadian(1)) * povRange);	// Left side of Azimuth
	
	point.y = (realityBounds.size.height / 2) + (radianToDegrees(M_PI_2 + viewAngle)  * 2.0);
	
	return point;
}

-(NSComparisonResult) LocationSortClosestFirst:(ARCoordinate *) s1 secondCoord:(ARCoordinate*) s2 {
    
	if ([s1 radialDistance] < [s2 radialDistance]) 
		return NSOrderedAscending;
	else if ([s1 radialDistance] > [s2 radialDistance]) 
		return NSOrderedDescending;
	else 
		return NSOrderedSame;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	// Later we may handle the Orientation of Faceup to show a Map.  For now let's ignore it.
	if (orientation != UIDeviceOrientationUnknown && orientation != UIDeviceOrientationFaceUp && orientation != UIDeviceOrientationFaceDown) {
		
		CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadian(0));
		CGRect bounds = [[UIScreen mainScreen] bounds];
		
		if (orientation == UIDeviceOrientationLandscapeLeft) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadian(90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
		}
		else if (orientation == UIDeviceOrientationLandscapeRight) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadian(-90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
		}
		else if (orientation == UIDeviceOrientationPortraitUpsideDown)
			transform = CGAffineTransformMakeRotation(degreesToRadian(180));
		
		[self setTransform:CGAffineTransformIdentity];
		[self setTransform: transform];
		[self setBounds:bounds];
		
		[self setDegreeRange:[self bounds].size.width / povRange];
		[self setDebugMode:NO];
	}
}

- (void)setDebugMode:(BOOL)flag {
	
	if ([self debugMode] == flag) {
		currentOrientation = [[UIDevice currentDevice] orientation];
		
		CGRect debugRect  = CGRectMake(0, [self bounds].size.height -20, [self bounds].size.width, 20);	
		[debugView setFrame: debugRect];
		return;
	}
	
	debugMode = flag;
	
	if ([self debugMode]) {
		debugView = [[UILabel alloc] initWithFrame:CGRectZero];
		[debugView setTextAlignment: UITextAlignmentCenter];
		[debugView setText: @"Waiting..."];
		[self addSubview:debugView];
		[self setupDebugPostion];
	}
	else 
		[debugView removeFromSuperview];
}
- (BOOL) debugMode {
    return debugMode;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


@end

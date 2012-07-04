//
//  GEOLocations.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//	Modified by S. Orban on 09/23/10
//  Copyright 2010 WiO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"


@class ARCoordinate;

@interface GEOLocations : NSObject {
	NSMutableArray *locationArray;
	TBXML * tbxml;	
}

- (id)init;
-(void) LoadLocations;
-(NSMutableArray*) getLocations;

	

@end

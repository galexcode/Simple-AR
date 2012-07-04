//
//  GEOLocations.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//	Modified (heavily) by S. Orban on 09/23/11
//

#import "GEOLocations.h"
#import "ARGeoCoordinate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@implementation GEOLocations

- (id)init {
	
	locationArray = [[NSMutableArray alloc] init];
	[self LoadLocations];
	return self;
}

-(void) LoadLocations {
	
	ARGeoCoordinate *tempCoordinate;
	CLLocation		*tempLocation;
	// NSLocalizedString(@"url", nil)
	NSLog(@"%@", NSLocalizedString(@"url", nil));
	tbxml = [[TBXML tbxmlWithURL:[NSURL URLWithString:NSLocalizedString(@"url", nil)]] retain];
	if (!tbxml.rootXMLElement) {
		tbxml = [[TBXML tbxmlWithXMLFile:@"test.xml"] retain];
	}
	TBXMLElement * root = tbxml.rootXMLElement;
	if (root) {		
		TBXMLElement * channel = [TBXML childElementNamed:@"channel" parentElement:root];
		if (channel) {
			TBXMLElement * item = [TBXML childElementNamed:@"item" parentElement:channel];

			while (item != nil) {
				NSString * title = [TBXML textForElement:[TBXML childElementNamed:@"title" parentElement:item]];
				NSString * stringToClean = [TBXML textForElement:[TBXML childElementNamed:@"description" parentElement:item]];
				stringToClean = [stringToClean stringByReplacingOccurrencesOfString:@"<div dir=\"ltr\">" withString:@""];
				stringToClean = [stringToClean stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
				NSString  * stringToSplit = [TBXML textForElement:[TBXML childElementNamed:@"georss:point" parentElement:item]];
				NSArray * latlong = [stringToSplit componentsSeparatedByString: @" "];
				tempLocation = [[CLLocation alloc] initWithLatitude:[[latlong objectAtIndex:0] floatValue] longitude:[[latlong objectAtIndex:1]floatValue]];
				tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation
														 locationTitle:title];
				tempCoordinate.subtitle = stringToClean;
				[locationArray addObject:tempCoordinate];
				[tempLocation release];
				item = [TBXML nextSiblingNamed:@"item" searchFromElement:item];
			}
		}
	}
	[tbxml release];
	
}

-(NSMutableArray*) getLocations 
{
	return locationArray;
}

- (void)dealloc {	
    [locationArray release];
    [super dealloc];
}


@end

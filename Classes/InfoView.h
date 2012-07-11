//
//  InfoView.h
//  ARTest
//
//  Created by Sébastien Orban on 5/10/10.
//  Copyright 2010 WiO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InfoView : UIView {
	UILabel * description;
}

@property (nonatomic) IBOutlet UILabel *description;

-(IBAction) memberButton:(id) sender;
-(IBAction) giftButton:(id) sender;
-(IBAction) closeButton:(id) sender;


@end

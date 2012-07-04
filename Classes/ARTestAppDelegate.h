//
//  ARTestAppDelegate.h
//  ARTest
//
//  Created by Sébastien Orban on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTestViewController;

@interface ARTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ARTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ARTestViewController *viewController;

@end


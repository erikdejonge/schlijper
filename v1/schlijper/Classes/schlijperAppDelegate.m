//
//  SchlijperAppDelegate.m
//  Schlijper
//
//  Created by rabshakeh on 8/14/09 - 9:59 AM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "schlijperAppDelegate.h"
#import "schlijperViewController.h"

@implementation schlijperAppDelegate

@synthesize window;
@synthesize viewController;


-(void) applicationDidFinishLaunching: (UIApplication *) application
{
    // Override point for customization after app launch
	[application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];	
    [ window addSubview:viewController.view ];
    [ window makeKeyAndVisible ];
}


-(void) dealloc
{
    [ viewController release ];
    [ window release ];
    [ super dealloc ];
}


@end

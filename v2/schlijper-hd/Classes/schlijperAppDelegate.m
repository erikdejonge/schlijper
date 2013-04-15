//
//  schlijperAppDelegate.m
//  schlijper
//
//  Created by rabshakeh on 10/1/09 - 1:20 PM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "schlijperAppDelegate.h"
#import "PhotoTest1Controller.h"

@implementation schlijperAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"tt://photoTest1" toViewController:[PhotoTest1Controller class]];
	
    //if (![navigator restoreViewControllers]) {
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://photoTest1"]];
    //}[
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}


@end

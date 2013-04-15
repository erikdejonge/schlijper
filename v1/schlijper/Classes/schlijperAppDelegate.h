//
//  SchlijperAppDelegate.h
//  Schlijper
//
//  Created by rabshakeh on 8/14/09 - 9:59 AM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class schlijperViewController;

@interface schlijperAppDelegate : NSObject<UIApplicationDelegate> {
    UIWindow                *window;
    schlijperViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow                *window;
@property (nonatomic, retain) IBOutlet schlijperViewController *viewController;

@end


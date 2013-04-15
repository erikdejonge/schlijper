//
//  SchlijperViewController.h
//  Schlijper
//
//  Created by rabshakeh on 8/14/09 - 9:59 AM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schlijperViewController : UIViewController {
    IBOutlet UIImageView    *myImageView;
    NSMutableArray          *myImages;
    int                     currentImage;
    UIActivityIndicatorView *progressIndicator;
}

@property (retain, nonatomic) UIImageView                      *myImageView;
@property (retain, nonatomic) NSMutableArray                   *myImages;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressIndicator;

-(IBAction)back    : (id)sender;
-(IBAction)forward : (id)sender;

@end


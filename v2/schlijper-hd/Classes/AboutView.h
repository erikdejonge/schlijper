//
//  AboutView.h
//  PhotoView
//
//  Created by rabshakeh on 9/28/09 - 10:27 AM.
//  Copyright 2009 Active8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface AboutView : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    IBOutlet UIWebView               *theWebView;
    IBOutlet UIActivityIndicatorView *progressIndicator;
    IBOutlet UITextView              *thedisclaimertekst;
    IBOutlet UIBarButtonItem         *backbtn;
    IBOutlet UIBarButtonItem         *forwardbtn;
    IBOutlet UIBarButtonItem         *actionbtn;
    IBOutlet UIBarButtonItem         *refreshbtn;	
    IBOutlet UIToolbar               *myToolbar;
	bool							 enablehistorybtns;
}

@property (retain, nonatomic) UIActivityIndicatorView *progressIndicator;
@property (retain, nonatomic) UIWebView               *theWebView;
@property (retain, nonatomic) UITextView              *thedisclaimertekst;
@property (retain, nonatomic) UIBarButtonItem         *backbtn;
@property (retain, nonatomic) UIBarButtonItem         *forwardbtn;
@property (retain, nonatomic) UIBarButtonItem         *actionbtn;
@property (retain, nonatomic) UIBarButtonItem         *refreshbtn;
@property (retain, nonatomic) UIToolbar               *myToolbar;


-(IBAction)toggleShowHide : (id)sender;
-(IBAction) closeAppGoToSafari;

@end

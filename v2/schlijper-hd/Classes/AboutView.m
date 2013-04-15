//
//  AboutView.m
//  PhotoView
//
//  Created by rabshakeh on 9/28/09 - 10:27 AM.
//  Copyright 2009 Active8. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

@synthesize theWebView;
@synthesize progressIndicator;
@synthesize thedisclaimertekst;
@synthesize backbtn;
@synthesize forwardbtn;
@synthesize actionbtn;
@synthesize refreshbtn;
@synthesize myToolbar;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
    if (self = [ super initWithNibName:nibNameOrNil bundle:nibBundleOrNil ])
    {
    }
    return(self);
}

-(void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error
{
    [ self dismissModalViewControllerAnimated:YES ];
}

-(BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
{
    NSString *url = [ request.URL absoluteString ];
	if ([url rangeOfString:@"http://"].length ==0) {
	    self.theWebView.scalesPageToFit = NO;
	}
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if ( [ url compare:@"mailto:thomas@schlijper.nl" ] == NSOrderedSame)
        {
            MFMailComposeViewController *picker = [ [ MFMailComposeViewController alloc ] init ];
            picker.mailComposeDelegate = self;
            [ picker setToRecipients: [ NSArray arrayWithObject:@"thomas@schlijper.nl" ] ];
            [ picker setSubject:@"About schlijper.nl" ];
            [ self presentModalViewController:picker animated:YES ];
            [ picker release ];
        }
        if ( [ url compare:@"mailto:info@active8.nl" ] == NSOrderedSame)
        {
            MFMailComposeViewController *picker = [ [ MFMailComposeViewController alloc ] init ];
            picker.mailComposeDelegate = self;
            [ picker setToRecipients: [ NSArray arrayWithObject:@"info@active8.nl" ] ];
            [ picker setSubject:@"About schlijper.nl app" ];
            [ self presentModalViewController:picker animated:YES ];
            [ picker release ];
        }

        if ( [ url compare:@"http://www.active8.nl/" ] == NSOrderedSame)
        {
            enablehistorybtns               = YES;
            self.actionbtn.enabled          = YES;
            self.refreshbtn.enabled          = YES;						
            self.theWebView.scalesPageToFit = YES;
        }
        if ( [ url compare:@"http://www.schlijper.nl/" ] == NSOrderedSame)
        {
            enablehistorybtns               = YES;
            self.actionbtn.enabled          = YES;
            self.refreshbtn.enabled          = YES;			
            self.theWebView.scalesPageToFit = YES;
        }
    }


    return(YES);
}


-(void) actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex: (NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        [ [ UIApplication sharedApplication ] openURL: self.theWebView.request.URL ];
    }
}

-(void) home
{
    [ self.navigationController popToRootViewControllerAnimated:YES ];
}

-(void) terug
{
    [ self.navigationController popViewControllerAnimated:YES ];
}

-(IBAction) closeAppGoToSafari
{
    UIActionSheet *as = [ [ UIActionSheet alloc ]
                          initWithTitle:@"Close app and open webpage in Safari?"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                          otherButtonTitles:@"Open Safari", nil ];

    [ as showInView:self.view ];
    [ as autorelease ];
}


-(void) viewDidLoad
{
    UIBarButtonItem *barButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed:@"home.png" ] style:UIBarButtonItemStyleBordered target:self action:@selector(home) ];

    self.navigationItem.rightBarButtonItem = barButtonItem;
    [ barButtonItem release ];

    self.navigationController.title = @"About";
    self.theWebView.scalesPageToFit = NO;
    self.thedisclaimertekst.hidden = YES;
    [ self.theWebView loadRequest: [ NSURLRequest requestWithURL: [ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource:@"aboutphotographer" ofType:@"html" ] isDirectory:NO ] ] ];
    self.forwardbtn.enabled = NO;
    self.backbtn.enabled    = NO;
    self.actionbtn.enabled  = NO;
            self.refreshbtn.enabled          = NO;			
    [ super viewDidLoad ];
}


-(void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation
{
	[self.theWebView reload];
}

// Override to allow orientations other than the default portrait orientation.
-(BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    // Return YES for supported orientations
    return(YES);
}

-(void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [ super didReceiveMemoryWarning ];

    // Release any cached data, images, etc that aren't in use.
}

-(void) viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [ super dealloc ];
}


-(void) webViewDidFinishLoad: (UIWebView *) webView
{
    self.forwardbtn.enabled = NO;
    self.backbtn.enabled    = NO;
    if (enablehistorybtns)
    {
        if (webView.canGoBack == YES)
        {
            self.backbtn.enabled = YES;
        }
        if (webView.canGoForward == YES)
        {
            self.forwardbtn.enabled = YES;
        }
    }
    ;
    [ self.progressIndicator stopAnimating ];
    self.title = [ webView stringByEvaluatingJavaScriptFromString: @"document.title" ];
}

-(void) webViewDidStartLoad: (UIWebView *) webView
{
    [ self.progressIndicator startAnimating ];
}

-(IBAction) toggleShowHide: (id) sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger          segment           = segmentedControl.selectedSegmentIndex;
    self.theWebView.scalesPageToFit = NO;	
	enablehistorybtns = NO;
    self.thedisclaimertekst.hidden = YES;
    self.theWebView.hidden         = NO;
    self.myToolbar.hidden          = NO;
    self.actionbtn.enabled         = NO;
          self.refreshbtn.enabled          = NO;			
    if (segment == 0)
    {
        self.theWebView.scalesPageToFit = NO;
        [ self.theWebView loadRequest: [ NSURLRequest requestWithURL: [ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource:@"aboutphotographer" ofType:@"html" ] isDirectory:NO ] ] ];
    }
    if (segment == 1)
    {
        self.theWebView.scalesPageToFit = NO;
        [ self.theWebView loadRequest: [ NSURLRequest requestWithURL: [ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource:@"aboutapp" ofType:@"html" ] isDirectory:NO ] ] ];
    }
    if (segment == 2)
    {
        self.title                     = @"Disclaimer";
        self.myToolbar.hidden          = YES;
        self.theWebView.hidden         = YES;
        self.thedisclaimertekst.hidden = NO;
    }
}

@end

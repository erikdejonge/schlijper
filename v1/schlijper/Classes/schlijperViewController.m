//
//  SchlijperViewController.m
//  Schlijper
//
//  Created by rabshakeh on 8/14/09 - 9:59 AM.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "schlijperViewController.h"
#import <QuartzCore/CAAnimation.h>
#import "ImagesCollector.h"
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation schlijperViewController

@synthesize myImageView;
@synthesize myImages;
@synthesize progressIndicator;



// The designated initializer. Override to perform setup that is required before the view is loaded.
-(id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
    if (self = [ super initWithNibName:nibNameOrNil bundle:nibBundleOrNil ])
    {
        // Custom initialization
    }
    return(self);
}


-(void) prevImg
{
    NSAutoreleasePool *autoreleasepool = [ [ NSAutoreleasePool alloc ] init ];

    if ( [ self.myImages count ] > 0)
    {
        NSString *myurl  = [ [ NSString alloc ] initWithFormat:@"http://www.schlijper.nl/%@", [ self.myImages objectAtIndex:currentImage ] ];
        NSString *mapURL = [ myurl stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding ];
        [ myurl release ];
        NSData   *imageData = [ [ NSData alloc ] initWithContentsOfURL: [ NSURL URLWithString:mapURL ] ];
        UIImage  *image     = [ [ UIImage alloc ] initWithData:imageData ];
        [ self.myImageView setImage:image ];
        [ imageData release ];
        [ image release ];
    }

    CATransition *myTransition = [ CATransition animation ];

    myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
    myTransition.type           = kCATransitionPush;
    myTransition.subtype        = kCATransitionFromLeft;
    [ self.myImageView.layer addAnimation:myTransition forKey: nil ];
    [ progressIndicator stopAnimating ];
    [ autoreleasepool release ];
}

-(IBAction) back: (id) sender
{
    currentImage -= 1;
    if (currentImage < 0)
    {
        currentImage = 0;
    }
    [ self.progressIndicator startAnimating ];
    [ NSThread detachNewThreadSelector:@selector(prevImg) toTarget:self withObject:nil ];
}

-(void) nextImg
{
    NSAutoreleasePool *autoreleasepool = [ [ NSAutoreleasePool alloc ] init ];

    if ( [ self.myImages count ] > 0)
    {
        NSString *myurl  = [ [ NSString alloc ] initWithFormat:@"http://www.schlijper.nl/%@", [ self.myImages objectAtIndex:currentImage ] ];
        NSString *mapURL = [ myurl stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding ];
        [ myurl release ];
        NSData   *imageData = [ [ NSData alloc ] initWithContentsOfURL: [ NSURL URLWithString:mapURL ] ];
        UIImage  *image     = [ [ UIImage alloc ] initWithData:imageData ];
        [ self.myImageView setImage:image ];
        [ imageData release ];
        [ image release ];
    }

    CATransition *myTransition = [ CATransition animation ];
    myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
    myTransition.type           = kCATransitionPush;
    myTransition.subtype        = kCATransitionFromRight;
    [ self.myImageView.layer addAnimation:myTransition forKey: nil ];
    [ progressIndicator stopAnimating ];
    [ autoreleasepool release ];
}

-(IBAction) forward: (id) sender
{
    currentImage += 1;
    if (currentImage >= [ self.myImages count ] - 1)
    {
        currentImage = [ self.myImages count ] - 1;
    }
    [ self.progressIndicator startAnimating ];
    [ NSThread detachNewThreadSelector:@selector(nextImg) toTarget:self withObject:nil ];
}

-(void) loadInitialImage
{
    NSAutoreleasePool *autoreleasepool = [ [ NSAutoreleasePool alloc ] init ];

    NSString          *url        = @"http://www.schlijper.nl/index.html";
    NSString          *escapedURL = [ url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding ];
    NSString          *page       = [ NSString stringWithContentsOfURL: [ NSURL URLWithString:escapedURL ] ];

    ImagesCollector   *collector = [ [ [ ImagesCollector alloc ] init ] autorelease ];
    HyperParser       *parser    = [ [ [ HyperParser alloc ] initWithString:page ] autorelease ];

    parser.delegate = collector;
    [ parser parse ];

	self.myImages = [ [ NSMutableArray alloc ] init ];
    for (NSString *url in [ collector urls ])
    {
        NSRange  textRange;
        NSString *substring = @"archive/";
        textRange = [ [ url lowercaseString ] rangeOfString: [ substring lowercaseString ] ];
		
        if (textRange.location != NSNotFound)
        {
            [ self.myImages addObject:url ];
        }
    }

    url             = @"http://www.schlijper.nl/index2.html";
    escapedURL      = [ url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding ];
    page            = [ NSString stringWithContentsOfURL: [ NSURL URLWithString:escapedURL ] ];
    collector       = [ [ [ ImagesCollector alloc ] init ] autorelease ];
    parser          = [ [ [ HyperParser alloc ] initWithString:page ] autorelease ];
    parser.delegate = collector;
    [ parser parse ];

    for (NSString *url in [ collector urls ])
    {
        NSRange  textRange;
        NSString *substring = @"archive/";
        textRange = [ [ url lowercaseString ] rangeOfString: [ substring lowercaseString ] ];

        if (textRange.location != NSNotFound)
        {
            [ self.myImages addObject:url ];
        }
    }

    currentImage  = 0;

    if ( [ self.myImages count ] > 0)
    {
        NSString *myurl  = [ [ NSString alloc ] initWithFormat:@"http://www.schlijper.nl/%@", [ self.myImages objectAtIndex:currentImage ] ];
        NSString *mapURL = [ myurl stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding ];
        [ myurl release ];
        NSData   *imageData = [ [ NSData alloc ] initWithContentsOfURL: [ NSURL URLWithString:mapURL ] ];
        UIImage  *image     = [ [ UIImage alloc ] initWithData:imageData ];

        [ self.myImageView setImage:image ];
        [ imageData release ];
        [ image release ];
    }
    [ progressIndicator stopAnimating ];
    [ autoreleasepool release ];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	exit(1);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void) viewDidLoad
{
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    [ progressIndicator hidesWhenStopped ];
    [ self.progressIndicator startAnimating ];
	
	
	const char *host_name = [@"www.schlijper.nl"cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
																				host_name);
    SCNetworkReachabilityFlags flags;
    bool success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && 
	!(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable) 
		
	{
		[ NSThread detachNewThreadSelector:@selector(loadInitialImage) toTarget:self withObject:nil ];
	}
	else {
		UIAlertView *alertTest = [ [ UIAlertView alloc ]
								  initWithTitle:@"Schlijper"
								  message: [ NSString stringWithFormat:@"This application requires an active internet connection, none found." ]
								  delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil ];
		[ alertTest addButtonWithTitle:@"Close application" ];
		[ alertTest show ];
		[ alertTest autorelease ];		

	}
	
    [ super viewDidLoad ];
}


// Override to allow orientations other than the default portrait orientation.
-(BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    // Return YES for supported orientations
    return(YES); //(interfaceOrientation == UIInterfaceOrientationPortrait);
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

@end

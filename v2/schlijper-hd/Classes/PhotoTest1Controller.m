#import "PhotoTest1Controller.h"
#import "MockPhotoSource.h"
#import "ImagesCollector.h"
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation PhotoTest1Controller

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	inError	= inError;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	for (NSDictionary* p in [[inResponseDictionary objectForKey:@"photos"] valueForKeyPath:@"photo"]) {
    /*
    for (id key in p) {      
      NSLog(@"key: %@, value: %@", key, [p objectForKey:key]);      
    }
    NSLog(@"-------------------------");
     */
		int w = [[p objectForKey:@"width_o"]intValue];
		int h = [[p objectForKey:@"height_o"]intValue];		
		if (h<w) {      
			[ myImages addObject:[[[MockPhoto alloc]
								   initWithURL:[p objectForKey:@"url_o"]
								   smallURL:[p objectForKey:@"url_s"]
								   size:CGSizeMake(480, 320)
								   caption:[p objectForKey:@"title"] ] autorelease] ];						
		}
		else {
			[ myImages addObject:[[[MockPhoto alloc]
								   initWithURL:[p objectForKey:@"url_o"]
								   smallURL:[p objectForKey:@"url_s"]
								   size:CGSizeMake(320, 480)
								   caption:[p objectForKey:@"title"] ] autorelease] ];						
		}		
	}
    self.photoSource = [ [ [ MockPhotoSource alloc ]
						  initWithType:MockPhotoSourceDelayed
						  title:@"schlijper"
						  photos:myImages
						  photos2:nil
						  ] autorelease ];	
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
    exit(1);
}

-(void) viewDidLoad
{
	myImages = [ [ NSMutableArray alloc ] init ];
    const char                 *host_name   = [ @"www.google.com" cStringUsingEncoding:NSASCIIStringEncoding ];
    SCNetworkReachabilityRef   reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
    SCNetworkReachabilityFlags flags;
    bool                       success     = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool                       isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	
    if (!isAvailable)
    {
        UIAlertView *alertTest = [ [ UIAlertView alloc ]
								  initWithTitle:@"schlijper"
								  message: [ NSString stringWithFormat:@"This application requires an active internet connection, none found." ]
								  delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil ];
        [ alertTest addButtonWithTitle:@"Close application" ];
        [ alertTest show ];
        [ alertTest autorelease ];
    }
	
	OFFlickrAPIContext *flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"136c5c3932e9dbeabec223c7b6386255" sharedSecret:@"45e8ab7490715bb4"];
	OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
	[flickrRequest setDelegate:self];
	flickrRequest.sessionInfo = 0;
	[flickrRequest callAPIMethodWithGET:@"flickr.photos.search" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"42959649@N05", @"user_id", @"date-taken-desc", @"sort", @"date_taken,url_s,url_o", @"extras", nil]];	
}

@end

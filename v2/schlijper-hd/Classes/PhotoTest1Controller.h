
#import <Three20/Three20.h>
#import "TTURLRequest.h"
#import "ObjectiveFlickr.h"

@interface PhotoTest1Controller : TTPhotoViewController<TTURLRequestDelegate, OFFlickrAPIRequestDelegate>
	NSMutableArray* myImages;
@end

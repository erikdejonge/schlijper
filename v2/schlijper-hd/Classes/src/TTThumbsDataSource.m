//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/TTThumbsDataSource.h"

// UI
#import "Three20/TTGlobalUI.h"
#import "Three20/TTGlobalUINavigator.h"
#import "Three20/TTPhotoSource.h"
#import "Three20/TTTableMoreButton.h"
#import "Three20/TTThumbsTableViewCell.h"

// Network
#import "Three20/TTGlobalNetwork.h"
#import "Three20/TTURLCache.h"

// Core
#import "Three20/TTGlobalCoreLocale.h"
#import "Three20/TTCorePreprocessorMacros.h"

static CGFloat kThumbSize = 75;
static CGFloat kThumbSpacing = 4;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTThumbsDataSource

@synthesize photoSource = _photoSource;
@synthesize delegate    = _delegate;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithPhotoSource:(id<TTPhotoSource>)photoSource
                 delegate:(id<TTThumbsTableViewCellDelegate>)delegate {
  if (self = [super init]) {
    _photoSource = [photoSource retain];
    _delegate = delegate;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_photoSource);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasMoreToLoad {
  return _photoSource.maxPhotoIndex+1 < _photoSource.numberOfPhotos;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)columnCount {
  CGFloat width = TTScreenBounds().size.width;
  return round((width - kThumbSpacing*2) / (kThumbSize+kThumbSpacing));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger maxIndex = _photoSource.maxPhotoIndex;
  NSInteger columnCount = self.columnCount;
  if (maxIndex >= 0) {
    maxIndex += 1;
    NSInteger count =  ceil((maxIndex / columnCount) + (maxIndex % columnCount ? 1 : 0));
    if (self.hasMoreToLoad) {
      return count + 1;
    } else {
      return count;
    }
  } else {
    return 0;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
  return _photoSource;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.row == [tableView numberOfRowsInSection:0]-1 && self.hasMoreToLoad) {
    NSString* text = TTLocalizedString(@"Load More Photos...", @"");
    NSString* caption = nil;
    if (_photoSource.numberOfPhotos == -1) {
      caption = [NSString stringWithFormat:TTLocalizedString(@"Showing %@ Photos", @""),
                 TTFormatInteger(_photoSource.maxPhotoIndex+1)];
    } else {
      caption = [NSString stringWithFormat:TTLocalizedString(@"Showing %@ of %@ Photos", @""),
                 TTFormatInteger(_photoSource.maxPhotoIndex+1),
                 TTFormatInteger(_photoSource.numberOfPhotos)];
    }

    return [TTTableMoreButton itemWithText:text subtitle:caption];
  } else {
    NSInteger columnCount = self.columnCount;
    return [_photoSource photoAtIndex:indexPath.row * columnCount];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
  if ([object conformsToProtocol:@protocol(TTPhoto)]) {
    return [TTThumbsTableViewCell class];
  } else {
    return [super tableView:tableView cellClassForObject:object];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)        tableView: (UITableView*)tableView
                     cell: (UITableViewCell*)cell
    willAppearAtIndexPath: (NSIndexPath*)indexPath {
  if ([cell isKindOfClass:[TTThumbsTableViewCell class]]) {
    TTThumbsTableViewCell* thumbsCell = (TTThumbsTableViewCell*)cell;
    thumbsCell.delegate = _delegate;
    thumbsCell.columnCount = self.columnCount;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView willInsertObject:(id)object
              atIndexPath:(NSIndexPath*)indexPath {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView willRemoveObject:(id)object
              atIndexPath:(NSIndexPath*)indexPath {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return TTLocalizedString(@"No Photos", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForEmpty {
  return TTLocalizedString(@"Loading...", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForError:(NSError*)error {
  return TTIMAGE(@"bundle://Three20.bundle/images/photoDefault.png");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return TTLocalizedString(@"Unable to load this photo set.", @"");
}


@end

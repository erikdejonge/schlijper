/*
 * Copyright (c) 2009 Dmitry Stadnik
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Dmitry Stadnik - initial API and implementation
 */

//
//  HyperParser.h
//

#import <Foundation/Foundation.h>


@interface HyperInput : NSObject {
    NSString   *source;
    NSUInteger position, length;
}

-(id)initWithString : (NSString *)string;
-(BOOL)hasNext;
-(unichar)next;
-(BOOL)startsWithPrefix          : (NSString *)prefix;
-(NSString *)substringToSuffix   : (NSString *)suffix;
-(NSString *)substringFromPrefix : (NSString *)prefix toSuffix : (NSString *)suffix;

@end


@class HyperParser;


@protocol HyperParserDelegate < NSObject >

@optional
- (void)parser : (HyperParser *)parser didStartElement : (NSString *)elementName attributes : (NSDictionary *)attributeDict;
-(void)parser  : (HyperParser *)parser didEndElement : (NSString *)elementName;
-(void)parser  : (HyperParser *)parser foundCharacters : (NSString *)string;
-(void)parser  : (HyperParser *)parser foundComment : (NSString *)string;
-(void)parser  : (HyperParser *)parser foundCDATA : (NSString *)string;

@end


@interface HyperParser : NSObject {
    NSDictionary            *codes;
    HyperInput              *input;
    id<HyperParserDelegate> delegate;
    BOOL                    abortParsing;
}

@property (assign) id<HyperParserDelegate> delegate;

-(id)initWithString : (NSString *)string;
-(void)parse;
-(void)abortParsing;
-(NSError *)parserError;
-(NSString *)decode : (NSString *)string;

@end

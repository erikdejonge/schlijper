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
//  ImagesCollector.m
//

#import "ImagesCollector.h"


@implementation ImagesCollector

-(id) init
{
    if (self = [ super init ])
    {
        urls = [ [ NSMutableArray alloc ] init ];
    }
    return(self);
}

-(void) dealloc
{
    [ urls release ];
    [ super dealloc ];
}

-(void) parser: (HyperParser *) parser
didStartElement: (NSString *) elementName
attributes: (NSDictionary *) attributeDict
{
	NSLog(elementName);
    if ( [ elementName caseInsensitiveCompare:@"img" ] == NSOrderedSame)
    {
        NSString *imageLink = [ attributeDict objectForKey:@"src" ];

        if (imageLink)
        {
            [ urls addObject:imageLink ];
        }
    }
}

-(NSArray *) urls
{
    return(urls);
}

@end

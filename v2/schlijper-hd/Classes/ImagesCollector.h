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
//  ImagesCollector.h
//

#import <Foundation/Foundation.h>
#import "HyperParser.h"


@interface ImagesCollector : NSObject<HyperParserDelegate> {
    NSMutableArray *urls;
}

-(NSArray *)urls;

@end

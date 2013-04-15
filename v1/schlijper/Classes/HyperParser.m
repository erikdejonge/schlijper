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
//  HyperParser.m
//

#import "HyperParser.h"


@implementation HyperInput

-(id) initWithString: (NSString *) string
{
    if (self = [ super init ])
    {
        source   = [ string retain ];
        position = 0;
        length   = [ source length ];
    }
    return(self);
}

-(void) dealloc
{
    [ source release ];
    [ super dealloc ];
}

-(BOOL) hasNext
{
    return(position < length);
}

-(unichar) next
{
    return( [ source characterAtIndex:position++ ]);
}

-(BOOL) startsWithPrefix: (NSString *) prefix
{
    if ( [ prefix length ] > (length - position))
    {
        return(NO);
    }
    for (NSUInteger i = 0; i < [ prefix length ]; i++)
    {
        if ( [ prefix characterAtIndex:i ] != [ source characterAtIndex:(position + i) ])
        {
            return(NO);
        }
    }
    return(YES);
}

-(NSString *) substringToSuffix: (NSString *) suffix
{
    NSRange range       = { position, length - position };
    NSRange suffixRange = [ source rangeOfString:suffix options:NSLiteralSearch range:range ];

    if (suffixRange.location == NSNotFound)
    {
        position = length;
        return( [ source substringFromIndex:position ]);
    }
    range.location = position;
    range.length   = suffixRange.location - range.location;
    NSString *content = [ source substringWithRange:range ];
    position = suffixRange.location + [ suffix length ];
    return(content);
}

-(NSString *) substringFromPrefix: (NSString *) prefix toSuffix: (NSString *) suffix
{
    if (! [ self startsWithPrefix:prefix ])
    {
        return(nil);
    }
    position += [ prefix length ];
    return( [ self substringToSuffix:suffix ]);
}

@end


@implementation HyperParser

@synthesize delegate;

-(id) initWithString: (NSString *) string
{
    if (self = [ super init ])
    {
        input        = [ [ HyperInput alloc ] initWithString:string ];
        abortParsing = NO;
        codes        = [ [ NSDictionary alloc ] initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource:@"codes" ofType:@"plist" ] ];
        if (!codes)
        {
            codes = [ [ NSMutableDictionary alloc ] initWithObjectsAndKeys:@"<", @"lt;", @">", @"gt;", @" ", @"nbsp;", nil ];
        }
    }
    return(self);
}

-(void) dealloc
{
    [ codes release ];
    [ input release ];
    [ super dealloc ];
}

-(BOOL) isWhitespace: (unichar) c
{
    return( [ [ NSCharacterSet whitespaceAndNewlineCharacterSet ] characterIsMember:c ]);
}

-(void) parseElement
{
    NSString            *elementName   = nil;
    NSMutableDictionary *attributeDict = [ NSMutableDictionary dictionary ];
    NSString            *attributeName = nil;
    BOOL                endOfElement   = NO; // starts with slash; closing part
    BOOL                emptyElement   = NO; // ends with slash; element without content
    NSMutableString     *buffer        = [ NSMutableString string ];
    unichar             chars [ 1 ];

    while ( [ input hasNext ])
    {
        unichar c = [ input next ];
        if ( [ self isWhitespace:c ])
        {
            // word border; buffer contains a token
            if ( [ buffer length ] == 0)
            {
                continue;                 // subsequent spaces
            }
            if (!elementName)
            {
                // first token is element name
                elementName = buffer;
                buffer      = [ NSMutableString string ];
            }
            else
            {
                // must be attribute name
                attributeName = buffer;
                buffer        = [ NSMutableString string ];
            }
        }
        else if (c == '=')
        {
            if ( [ buffer length ] > 0)
            {
                attributeName = buffer;
                buffer        = [ NSMutableString string ];
            }
            // now goes attribute value
            unichar firstQuote = '\0';
            while ( [ input hasNext ])
            {
                c = [ input next ];
                if ( [ self isWhitespace:c ])
                {
                    if (firstQuote != '\0')
                    {
                        // space inside quotes
                        chars [ 0 ] = c;
                        [ buffer appendString: [ NSString stringWithCharacters:chars length:1 ] ];
                    }
                    else if ( [ buffer length ] > 0)
                    {
                        // end of unquoted attribute value
                        if (attributeName)
                        {
                            [ attributeDict setObject:buffer forKey:attributeName ];
                            attributeName = nil;
                        }
                        buffer = [ NSMutableString string ];
                        break;
                    }
                    // else leading spaces - ignore
                }
                else if (c == '\'' || c == '"')
                {
                    if (firstQuote == c)
                    {
                        // last quote
                        if (attributeName)
                        {
                            [ attributeDict setObject:buffer forKey:attributeName ];
                            attributeName = nil;
                        }
                        buffer = [ NSMutableString string ];
                        break;
                    }
                    if ( [ buffer length ] == 0 && firstQuote == '\0')
                    {
                        // first quote
                        firstQuote = c;
                    }
                    else
                    {
                        // nested quote; add as normal char
                        // it's error if firstQuote == '\0' but we will ignore this
                        chars [ 0 ] = c;
                        [ buffer appendString: [ NSString stringWithCharacters:chars length:1 ] ];
                    }
                }
                else
                {
                    chars [ 0 ] = c;
                    [ buffer appendString: [ NSString stringWithCharacters:chars length:1 ] ];
                }
            }
            // try to recover incomplete attribute value
            if (attributeName)
            {
                [ attributeDict setObject:buffer forKey:attributeName ];
                attributeName = nil;
            }
            buffer = [ NSMutableString string ];
        }
        else if (c == '/')
        {
            // buffer may contain element name
            if ( [ buffer length ] > 0)
            {
                if (!elementName)
                {
                    elementName = buffer;
                }
                buffer = [ NSMutableString string ];
            }
            if (elementName)
            {
                emptyElement = YES;
            }
            else
            {
                endOfElement = YES;
            }
        }
        else if (c == '>')
        {
            // element has ended but buffer may contain element name
            if ( [ buffer length ] > 0)
            {
                if (!elementName)
                {
                    elementName = buffer;
                }
                // no need to empty buffer
            }
            break;
        }
        else
        {
            chars [ 0 ] = c;
            [ buffer appendString: [ NSString stringWithCharacters:chars length:1 ] ];
            emptyElement = NO;
        }
    }
    if (elementName)
    {
        if (endOfElement)
        {
            if ( [ delegate respondsToSelector:@selector(parser:didEndElement:) ])
            {
                [ delegate parser:self didEndElement:elementName ];
            }
        }
        else
        {
            if ( [ delegate respondsToSelector:@selector(parser:didStartElement:attributes:) ])
            {
                [ delegate parser:self didStartElement:elementName attributes:attributeDict ];
            }
            if (emptyElement && !abortParsing)
            {
                if ( [ delegate respondsToSelector:@selector(parser:didEndElement:) ])
                {
                    [ delegate parser:self didEndElement:elementName ];
                }
            }
        }
    }
}

-(void) parse
{
    while ( [ input hasNext ])
    {
        if (abortParsing)
        {
            break;
        }
        NSString *string = [ input substringToSuffix:@"<" ];
        if ( [ string length ] > 0)
        {
            if ( [ delegate respondsToSelector:@selector(parser:foundCharacters:) ])
            {
                [ delegate parser:self foundCharacters:string ];
                if (abortParsing)
                {
                    break;
                }
            }
        }
        // CDATA
        string = [ input substringFromPrefix:@"![CDATA[" toSuffix:@"]]>" ];
        if (string)
        {
            if ( [ delegate respondsToSelector:@selector(parser:foundCDATA:) ])
            {
                [ delegate parser:self foundCDATA:string ];
            }
            continue;
        }
        // Comment
        string = [ input substringFromPrefix:@"!--" toSuffix:@"-->" ];
        if (string)
        {
            if ( [ delegate respondsToSelector:@selector(parser:foundComment:) ])
            {
                [ delegate parser:self foundComment:string ];
            }
            continue;
        }
        // Processing Instruction... ignore for now
        string = [ input substringFromPrefix:@"?" toSuffix:@"?>" ];
        if (string)
        {
            continue;
        }
        // DOCTYPE... ignore for now
        string = [ input substringFromPrefix:@"!" toSuffix:@">" ];
        if (string)
        {
            continue;
        }
        [ self parseElement ];
    }
}

-(void) abortParsing
{
    abortParsing = YES;
}

-(NSError *) parserError
{
    return(nil);
}

-(BOOL) string: (NSString *) string startsWithPrefix: (NSString *) prefix atOffset: (NSUInteger) offset
{
    if ( [ prefix length ] > ( [ string length ] - offset))
    {
        return(NO);
    }
    for (NSUInteger i = 0; i < [ prefix length ]; i++)
    {
        if ( [ prefix characterAtIndex:i ] != [ string characterAtIndex:(offset + i) ])
        {
            return(NO);
        }
    }
    return(YES);
}

-(NSString *) decode: (NSString *) string
{
    if (!string)
    {
        return(string);
    }
    NSMutableString *result = nil;
    NSRange         range   = { 0, [ string length ] };
    for ( ; ;)
    {
        NSRange codeRange = [ string rangeOfString:@"&" options:NSLiteralSearch range:range ];
        if (codeRange.location == NSNotFound)
        {
            break;
        }
        if (!result)
        {
            result = [ NSMutableString string ];
        }
        NSRange leadRange = { range.location, codeRange.location - range.location };
        [ result appendString: [ string substringWithRange:leadRange ] ];
        range.location = codeRange.location;
        range.length   = [ string length ] - range.location;
        NSUInteger offset   = codeRange.location + 1;
        BOOL       replaced = NO;
        for (NSString *code in [ codes allKeys ])
        {
            if ( [ self string:string startsWithPrefix:code atOffset:offset ])
            {
                NSString *value = [ codes objectForKey:code ];
                [ result appendString:value ];
                replaced = YES;
                NSUInteger codeLength = [ code length ] + 1;               // '&'
                range.location += codeLength;
                range.length   -= codeLength;
                break;
            }
        }
        if (!replaced)
        {
            [ result appendString:@"&" ];
            range.location++;
            range.length--;
        }
    }
    if (!result)
    {
        return(string);
    }
    [ result appendString: [ string substringWithRange:range ] ];
    return(result);
}

@end

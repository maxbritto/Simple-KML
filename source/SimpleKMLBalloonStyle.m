//
//  SimpleKMLBalloonStyle.m
//
//  Created by Justin R. Miller on 7/6/10.
//  Copyright MapBox 2010-2013.
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//      * Redistributions of source code must retain the above copyright
//        notice, this list of conditions and the following disclaimer.
//  
//      * Redistributions in binary form must reproduce the above copyright
//        notice, this list of conditions and the following disclaimer in the
//        documentation and/or other materials provided with the distribution.
//  
//      * Neither the name of MapBox, nor the names of its contributors may be
//        used to endorse or promote products derived from this software
//        without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "SimpleKMLBalloonStyle.h"

@implementation SimpleKMLBalloonStyle

@synthesize backgroundColor;
@synthesize textColor;
@synthesize text;

- (id)initWithXMLNode:(CXMLNode *)node sourceURL:sourceURL error:(NSError **)error
{
    self = [super initWithXMLNode:node sourceURL:sourceURL error:error];
    
    if (self != nil)
    {
        backgroundColor = [UIColor whiteColor];
        textColor       = [UIColor blackColor];
        
        for (CXMLNode *child in [node children])
        {
            if ([[child name] isEqualToString:@"bgColor"])
            {
                NSString *colorString = [child stringValue];
             
                backgroundColor = [SimpleKML colorForString:colorString];
            }
            else if ([[child name] isEqualToString:@"textColor"])
            {
                NSString *colorString = [child stringValue];
                
                textColor = [SimpleKML colorForString:colorString];
            }else if ([child kind] == CXMLElementKind && [[child name] isEqualToString:@"text"])
            {
                text = [child stringValue];
            }
        }
    }
    
    return self;
}

@end
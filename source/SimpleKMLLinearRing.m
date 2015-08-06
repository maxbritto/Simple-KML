//
//  SimpleKMLLinearRing.m
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

#import "SimpleKMLLinearRing.h"
#import <CoreLocation/CoreLocation.h>

@implementation SimpleKMLLinearRing

@synthesize coordinates;

- (id)initWithXMLNode:(CXMLNode *)node sourceURL:sourceURL error:(NSError **)error
{
    self = [super initWithXMLNode:node sourceURL:sourceURL error:error];
    
    if (self != nil)
    {
        NSString* errorMessage = nil;
        coordinates = nil;
        NSCharacterSet* const coordinatesSeparator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* const coordinatePartsSeparator = @",";
        NSMutableArray *parsedCoordinates = [NSMutableArray array];
        
        for (CXMLNode *child in [node children])
        {
            if ([[child name] isEqualToString:@"coordinates"])
            {
                [parsedCoordinates removeAllObjects];
                NSArray *coordinateStrings = [[child stringValue] componentsSeparatedByCharactersInSet:coordinatesSeparator];
                
                for (__strong NSString *coordinateString in coordinateStrings)
                {
                    if ([coordinateString length])
                    {
                        NSArray *parts = [coordinateString componentsSeparatedByString:coordinatePartsSeparator];
                        
                        // there should be longitude, latitude, and optionally, altitude
                        size_t partsCount = [parts count];
                        if (partsCount == 2 || partsCount == 3)
                        {
                            double longitude = [[parts objectAtIndex:0] doubleValue];
                            double latitude  = [[parts objectAtIndex:1] doubleValue];
                            
                            // there should be valid values for latitude & longitude
                            //
                            if (longitude >= -180 && longitude <= 180
                                && latitude >= -90 && latitude <= 90) {
                                CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                                [parsedCoordinates addObject:coordinate];
                            } else {
                                errorMessage = @"Improperly formed KML (Invalid LinearRing coordinates values)";
                            }
                        }
                    }
                }
                
                coordinates = [NSArray arrayWithArray:parsedCoordinates];
            }
        }
        
        if ([coordinates count] >= 4)
        {
            // the first and last coordinate should be the same
            CLLocation* firstCoordinates = [coordinates firstObject];
            CLLocation* lastCoordinates = [coordinates lastObject];
            if (firstCoordinates.coordinate.latitude  != lastCoordinates.coordinate.latitude ||
                firstCoordinates.coordinate.longitude != lastCoordinates.coordinate.longitude)
            {
                errorMessage = @"Improperly formed KML (LinearRing does not form complete path)";
            }
        } else {
            errorMessage = @"Improperly formed KML (LinearRing has less than four coordinates)";
        }
        
        
        
        if (errorMessage != nil) {
            if (error) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage
                                                                     forKey:NSLocalizedFailureReasonErrorKey];
                *error = [NSError errorWithDomain:SimpleKMLErrorDomain code:SimpleKMLParseError userInfo:userInfo];
            }
            
            self = nil;
        }
    }
    
    return self;
}

@end
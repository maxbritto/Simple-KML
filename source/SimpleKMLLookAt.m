//
//  SimpleKMLLookAt.m
//  Pods
//
//  Created by Maxime Britto on 21/07/2015.
//
//

#import "SimpleKMLLookAt.h"

@implementation SimpleKMLLookAt

@synthesize tilt;
@synthesize heading;
@synthesize altitude;
@synthesize coordinate;
@synthesize range;

- (id)initWithXMLNode:(CXMLNode *)node sourceURL:sourceURL error:(NSError **)error
{
    self = [super initWithXMLNode:node sourceURL:sourceURL error:error];
    
    if (self != nil)
    {
        CLLocationDegrees latitude = 0, longitude = 0;
        for (CXMLNode *child in [node children])
        {
            if ([[child name] isEqualToString:@"altitude"]) {
                altitude = [[child stringValue] doubleValue];
            } else if ([[child name] isEqualToString:@"heading"]) {
                heading = [[child stringValue] doubleValue];
            } else if ([[child name] isEqualToString:@"tilt"]) {
                tilt = [[child stringValue] doubleValue];
            } else if ([[child name] isEqualToString:@"latitude"]) {
                latitude = [[child stringValue] doubleValue];
            } else if ([[child name] isEqualToString:@"longitude"]) {
                longitude = [[child stringValue] doubleValue];
            }else if ([[child name] isEqualToString:@"range"]) {
                range = [[child stringValue] doubleValue];
            }
        }
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    return self;
}

@end

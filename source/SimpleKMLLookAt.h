//
//  SimpleKMLLookAt.h
//  Pods
//
//  Created by Maxime Britto on 21/07/2015.
//
//

#import <CoreLocation/CoreLocation.h>
#import "SimpleKMLObject.h"

@interface SimpleKMLLookAt : SimpleKMLObject
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign, readonly) CGFloat tilt;
@property (nonatomic, assign, readonly) CLLocationDirection heading;
@property (nonatomic, assign, readonly) CLLocationDistance altitude;
@property (nonatomic, assign, readonly) CLLocationDistance range;
@end

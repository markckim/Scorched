//
//  BMDamage.m
//  Scorched
//
//  Created by Mark Kim on 3/18/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMDamage.h"

@implementation BMDamage

- (void)dealloc
{    
    [super dealloc];
}

+ (id)damageWithCenterPoint:(CGPoint)centerPoint
                     radius:(CGFloat)radius
{
    return [[[self alloc] initWithCenterPoint:centerPoint
                                       radius:radius] autorelease];
}

+ (id)damageWithCenterPixelPoint:(CGPoint)centerPixelPoint
                     pixelRadius:(CGFloat)pixelRadius
{
    return [[[self alloc] initWithCenterPixelPoint:centerPixelPoint
                                        pixelRadius:pixelRadius] autorelease];
}

- (id)initWithCenterPoint:(CGPoint)centerPoint
                   radius:(CGFloat)radius
{
    if (self = [super init]) {
        _centerPoint = ccpMult(ccp(roundf(centerPoint.x), roundf(centerPoint.y)), CC_CONTENT_SCALE_FACTOR());
        _radius = roundf(radius) * CC_CONTENT_SCALE_FACTOR();
    }
    return self;
}

- (id)initWithCenterPixelPoint:(CGPoint)centerPixelPoint
                   pixelRadius:(CGFloat)pixelRadius
{
    if (self = [super init]) {
        _centerPoint = ccp(roundf(centerPixelPoint.x), roundf(centerPixelPoint.y));
        _radius = roundf(pixelRadius);
    }
    return self;
}

@end

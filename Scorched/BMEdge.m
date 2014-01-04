//
//  BMEdge.m
//  Scorched
//
//  Created by Mark Kim on 3/16/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMEdge.h"

@implementation BMEdge

+ (id)edgeWithPoint1:(CGPoint)point1
              point2:(CGPoint)point2
{
    return [[[self alloc] initEdgeWithPoint1:point1
                                      point2:point2] autorelease];
}

+ (id)edgeWithPixelPoint1:(CGPoint)pixelPoint1 pixelPoint2:(CGPoint)pixelPoint2
{
    return [[[self alloc] initEdgeWithPixelPoint1:pixelPoint1
                                      pixelPoint2:pixelPoint2] autorelease];
}

- (id)initEdgeWithPoint1:(CGPoint)point1
                  point2:(CGPoint)point2
{
    if (self = [super init]) {
        self.modelType = kEdgeModel;
        _point1 = ccpMult(point1, CC_CONTENT_SCALE_FACTOR());
        _point2 = ccpMult(point2, CC_CONTENT_SCALE_FACTOR());
    }
    return self;
}

- (id)initEdgeWithPixelPoint1:(CGPoint)pixelPoint1 pixelPoint2:(CGPoint)pixelPoint2
{
    if (self = [super init]) {
        self.modelType = kEdgeModel;
        _point1 = pixelPoint1;
        _point2 = pixelPoint2;
    }
    return self;
}

@end

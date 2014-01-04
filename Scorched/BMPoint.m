//
//  BMPoint.m
//  Scorched
//
//  Created by Mark Kim on 3/30/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMPoint.h"
#import "util_functions.h"

@implementation BMPoint

- (void)dealloc
{    
    [super dealloc];
}

- (CGPoint)nextNeighbor
{
    BMDirectionType nextNeighborDirection = (_neighborDirection + 1) % 8;
    _relativeDirection = relativeDirection(_neighborDirection, nextNeighborDirection);
    
    _neighborDirection = nextNeighborDirection;
    CGPoint unitVector = unitVectorForDirection(nextNeighborDirection);
    CGPoint vectorToAdd = ccpMult(unitVector, NEIGHBOR_STEP);
    
    return ccpAdd(_point, vectorToAdd);
}

+ (id)pointWithPoint:(CGPoint)point
       fromDirection:(BMDirectionType)directionType
{
    return [[[self alloc] initWithPoint:point
                          fromDirection:directionType] autorelease];
}

+ (id)pointWithPixelPoint:(CGPoint)pixelPoint
            fromDirection:(BMDirectionType)directionType
{
    return [[[self alloc] initWithPixelPoint:pixelPoint
                               fromDirection:directionType] autorelease];
}

- (id)initWithPoint:(CGPoint)point
      fromDirection:(BMDirectionType)directionType
{
    if (self = [super init]) {
        _point = ccpMult(point, CC_CONTENT_SCALE_FACTOR());
        _neighborDirection = directionType;
    }
    return self;
}

- (id)initWithPixelPoint:(CGPoint)pixelPoint
           fromDirection:(BMDirectionType)directionType
{
    if (self = [super init]) {
        _point = pixelPoint;
        _neighborDirection = directionType;
    }
    return self;
}

@end

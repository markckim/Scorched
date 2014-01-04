//
//  BMDebugSprite.m
//  Scorched
//
//  Created by Mark Kim on 5/4/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMDebugSprite.h"

#import "BMEdge.h"
#import "BMGround.h"

#import "util_functions.h"

@implementation BMDebugSprite

- (void)dealloc
{
    [_circleEdges release]; _circleEdges = nil;
    [_groundUnits release]; _groundUnits = nil;
    
    [super dealloc];
}

- (void)draw
{
    [super draw];
    
    if (DEBUG_DRAW) {
        
        ccDrawColor4F(1.0, 0.0, 0.0, 1.0);
        glLineWidth(DEBUG_LINE_WIDTH);
        if (_groundUnits && [_groundUnits count] > 0) {
            for (BMGround *ground in _groundUnits) {
                for (NSArray *pointArray in ground.edgePoints) {
                    int stride = FIXTURE_STRIDE;
                    for (int i=0; i<[pointArray count]; ++i) {
                        if (i % stride != 0) {
                            continue;
                        }
                        NSValue *pointValue1;
                        NSValue *pointValue2;
                        if (i < [pointArray count]) {
                            pointValue1 = (NSValue *)[pointArray objectAtIndex:i];
                            int strideLeft = [pointArray count] - i;
                            
                            if (strideLeft > stride) {
                                pointValue2 = (NSValue *)[pointArray objectAtIndex:i+stride];
                            } else {
                                pointValue2 = (NSValue *)[pointArray objectAtIndex:0];
                            }
                            CGPoint pixelPoint1 = [pointValue1 CGPointValue];
                            CGPoint pixelPoint2 = [pointValue2 CGPointValue];
                            ccDrawLine(ccpMult(pixelPoint1, 1/CC_CONTENT_SCALE_FACTOR()),
                                       ccpMult(pixelPoint2, 1/CC_CONTENT_SCALE_FACTOR()));
                        }
                    }
                }
            }
        }
        
        ccDrawColor4F(0.0, 1.0, 0.0, 1.0);
        glLineWidth(DEBUG_LINE_WIDTH);
        if (_circleEdges && [_circleEdges count] > 0) {
            for (BMEdge *edge in _circleEdges) {
                ccDrawLine(ccpMult(edge.point1, 1/CC_CONTENT_SCALE_FACTOR()),
                           ccpMult(edge.point2, 1/CC_CONTENT_SCALE_FACTOR()));
            }
        }
    }
}

- (void)createEdgesForCircleWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius
{
    for (int degrees=0; degrees < 359; ++degrees) {
        CGPoint vector1 = vectorRotatedByAngleDegrees(ccp(radius, 0.0), degrees);
        CGPoint vector2 = vectorRotatedByAngleDegrees(ccp(radius, 0.0), degrees+1);
        CGPoint point1 = ccp(centerPoint.x + vector1.x, centerPoint.y + vector1.y);
        CGPoint point2 = ccp(centerPoint.x + vector2.x, centerPoint.y + vector2.y);
        
        BMEdge *edge = [BMEdge edgeWithPoint1:point1 point2:point2];
        [_circleEdges addObject:edge];
    }
}

- (id)initWithGroundUnits:(NSArray *)groundUnits
{
    if (self = [super init]) {
        _circleEdges = [[NSMutableArray alloc] init];
        _groundUnits = [groundUnits retain];
    }
    return self;
}

@end

//
//  basic_functions.h
//  Scorched
//
//  Created by Mark Kim on 4/12/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#ifndef Scorched_basic_functions_h
#define Scorched_basic_functions_h

typedef unsigned char uint8;

typedef struct {
    CGFloat origin;
    CGFloat length;
} BMRectSegment;

CG_INLINE BMRectSegment
BMRectSegmentMake(CGFloat origin, CGFloat length)
{
    BMRectSegment segment;
    segment.origin = origin;
    segment.length = length;
    return segment;
}

CG_INLINE BMRectSegment
rectSegmentIntersectingSegments(BMRectSegment segment1, BMRectSegment segment2)
{
    int origin1 = (int)roundf(segment1.origin);
    int length1 = (int)roundf(segment1.length);
    int origin2 = (int)roundf(segment2.origin);
    int length2 = (int)roundf(segment2.length);
    
    BMRectSegment segmentToReturn = BMRectSegmentMake(0.0, 0.0);
    if (origin2 >= origin1 && origin2 <= (origin1 + length1) && MIN(origin1 + length1, origin2 + length2) - origin2 >= 1) {
        segmentToReturn.origin = origin2;
        segmentToReturn.length = MIN(origin1 + length1, origin2 + length2) - origin2;
    } else if (origin1 >= origin2 && origin1 <= (origin2 + length2) && MIN(origin1 + length1, origin2 + length2) - origin2 >= 1) {
        segmentToReturn.origin = origin1;
        segmentToReturn.length = MIN(origin1 + length1, origin2 + length2) - origin1;
    }
    return segmentToReturn;
}

CG_INLINE CGRect
rectIntersectingRects(CGRect rect1, CGRect rect2)
{
    BMRectSegment segmentX1 = BMRectSegmentMake(rect1.origin.x, rect1.size.width);
    BMRectSegment segmentX2 = BMRectSegmentMake(rect2.origin.x, rect2.size.width);
    BMRectSegment segmentY1 = BMRectSegmentMake(rect1.origin.y, rect1.size.height);
    BMRectSegment segmentY2 = BMRectSegmentMake(rect2.origin.y, rect2.size.height);
    
    BMRectSegment segmentX = rectSegmentIntersectingSegments(segmentX1, segmentX2);
    BMRectSegment segmentY = rectSegmentIntersectingSegments(segmentY1, segmentY2);
    
    return CGRectMake(segmentX.origin, segmentY.origin, segmentX.length, segmentY.length);
}

CG_INLINE BOOL
doesCircleIntersectRect(CGPoint centerPoint, CGFloat radius, CGRect rect)
{
    // Find the closest point to the circle within the rectangle
    CGFloat closestX = clampf(centerPoint.x, rect.origin.x, rect.origin.x + rect.size.width);
    CGFloat closestY = clampf(centerPoint.y, rect.origin.y, rect.origin.y + rect.size.height);
    
    // Calculate the distance between the circle's center and this closest point
    CGFloat distanceX = centerPoint.x - closestX;
    CGFloat distanceY = centerPoint.y - closestY;
    
    // If the distance is less than the circle's radius, an intersection occurs
    CGFloat distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    CGFloat radiusSquared = radius * radius;
    return distanceSquared < radiusSquared;
}

CG_INLINE CGRect
pixelRectForSprite(CCSprite *sprite, int expandByPixels)
{
    return CGRectMake(roundf((sprite.position.x - 0.5 * sprite.contentSize.width)) * CC_CONTENT_SCALE_FACTOR() - expandByPixels,
                      roundf((sprite.position.y - 0.5 * sprite.contentSize.height)) * CC_CONTENT_SCALE_FACTOR() - expandByPixels,
                      roundf(sprite.contentSize.width) * CC_CONTENT_SCALE_FACTOR() + 2.0 * expandByPixels,
                      roundf(sprite.contentSize.height) * CC_CONTENT_SCALE_FACTOR() + 2.0 * expandByPixels);
}

CG_INLINE CGRect
pixelRectForRect(CGRect rect, int expandByPixels)
{
    return CGRectMake(rect.origin.x * CC_CONTENT_SCALE_FACTOR() - expandByPixels,
                      rect.origin.y * CC_CONTENT_SCALE_FACTOR() - expandByPixels,
                      rect.size.width * CC_CONTENT_SCALE_FACTOR() + 2.0 * expandByPixels,
                      rect.size.height * CC_CONTENT_SCALE_FACTOR() + 2.0 * expandByPixels);
}

CG_INLINE CGRect
rectForRect(CGRect rect, int expandByPoints)
{
    return CGRectMake(rect.origin.x - expandByPoints,
                      rect.origin.y - expandByPoints,
                      rect.size.width + 2.0 * expandByPoints,
                      rect.size.height + 2.0 * expandByPoints);
}

CG_INLINE CGRect
rectBoundingCircle(CGPoint centerPoint, CGFloat radius)
{
    return CGRectMake(centerPoint.x - radius,
                      centerPoint.y - radius,
                      2.0 * radius,
                      2.0 * radius);
}

CG_INLINE NSString*
stringForPoint(CGPoint point)
{
    CGPoint roundedPoint = ccp(roundf(point.x), roundf(point.y));
    return [NSString stringWithFormat:@"%d,%d", (int)roundedPoint.x, (int)roundedPoint.y];
}

CG_INLINE NSString*
stringForSize(CGSize size)
{
    CGSize roundedSize = CGSizeMake(roundf(size.width), roundf(size.height));
    return [NSString stringWithFormat:@"[%d, %d]", (int)roundedSize.width, (int)roundedSize.height];
}

CG_INLINE NSString*
stringForRect(CGRect rect)
{
    return [NSString stringWithFormat:@"[%d, %d, %d, %d]",
            (int)roundf(rect.origin.x), (int)roundf(rect.origin.y), (int)roundf(rect.size.width), (int)roundf(rect.size.height)];
}

CG_INLINE int
indexForPoint(CGPoint point, CGRect viewRect)
{
    //enforce rounding
    CGPoint roundedPixelPoint = ccp(roundf(point.x), roundf(point.y));
    int x = (int)roundedPixelPoint.x;
    int y = (int)roundedPixelPoint.y;
    int offsetX = (int)viewRect.origin.x;
    int offsetY = (int)viewRect.origin.y;
    int widthInPixels = (int)viewRect.size.width;
    
    //NSAssert(x >= offsetX && x < (widthInPixels + offsetX), @"ERROR: x is outside rect!");
    //NSAssert(y >= offsetY && y < (heightInPixels + offsetY), @"ERROR: y is outside rect!");
    
    return ((x - offsetX) + (y - offsetY) * widthInPixels);
}

CG_INLINE NSValue*
addPointToArray(CGPoint point, NSMutableArray *arr)
{
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    [arr addObject:pointValue];
    return pointValue;
}

#endif

//
//  physics_functions.h
//  Scorched
//
//  Created by Mark Kim on 4/9/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#ifndef Scorched_physics_functions_h
#define Scorched_physics_functions_h

#import "basic_functions.h"
#import "enum_constants.h"

CG_INLINE BMDirectionType
nextClockwiseDirection(BMDirectionType directionType)
{
    return (BMDirectionType)((directionType + 1) % 8);
}

CG_INLINE CGPoint
unitVectorForDirection(BMDirectionType directionType)
{
    CGPoint unitVector;
    
    switch (directionType) {
        case kWest:
            unitVector = ccp(-1.0, 0.0);
            break;
        case kNorthWest:
            unitVector = ccp(-1.0, 1.0);
            break;
        case kNorth:
            unitVector = ccp(0.0, 1.0);
            break;
        case kNorthEast:
            unitVector = ccp(1.0, 1.0);
            break;
        case kEast:
            unitVector = ccp(1.0, 0.0);
            break;
        case kSouthEast:
            unitVector = ccp(1.0, -1.0);
            break;
        case kSouth:
            unitVector = ccp(0.0, -1.0);
            break;
        case kSouthWest:
            unitVector = ccp(-1.0, -1.0);
            break;
        default:
            debug(@"ERROR: unitVector not found!");
            unitVector = ccp(-1.0, 0.0);
    }
    return unitVector;
}

CG_INLINE BMDirectionType
relativeDirection(BMDirectionType direction1, BMDirectionType direction2)
{
    // assumptions:
    // * direction1 and direction2 must be adjacent
    
    CGPoint unitVector1 = unitVectorForDirection(direction1);
    CGPoint unitVector2 = unitVectorForDirection(direction2);
    
    int x1 = (int)unitVector1.x;
    int y1 = (int)unitVector1.y;
    int x2 = (int)unitVector2.x;
    int y2 = (int)unitVector2.y;
    //NSAssert((x2 - x1) == 0 || (y2 - y1) == 0, @"directions aren't adjacent!");
    
    BMDirectionType directionTypeToReturn;
    if ((x2 - x1) == 0) {
        // it will be either north or south
        if ((y2 - y1) > 0) {
            directionTypeToReturn = kSouth;
        } else {
            directionTypeToReturn = kNorth;
        }
    } else {
        if ((x2 - x1) > 0) {
            directionTypeToReturn = kWest;
        } else {
            directionTypeToReturn = kEast;
        }
    }
    return directionTypeToReturn;
}

CG_INLINE CGFloat
angleRadiansForVector(CGPoint vector)
{
    CGFloat angleRadians = atanf((CGFloat)vector.y / (CGFloat)vector.x);
    
    return angleRadians;
}

CG_INLINE CGFloat
angleDegreesForVector(CGPoint vector)
{
    CGFloat angleRadians = atanf((CGFloat)vector.y / (CGFloat)vector.x);
    CGFloat angleDegrees = angleRadians * 180.0 / M_PI;
    
    return angleDegrees;
}

CG_INLINE CGPoint
unitVectorFromTo(CGPoint startingPoint, CGPoint endingPoint)
{
    CGFloat lengthX = endingPoint.x - startingPoint.x;
    CGFloat lengthY = endingPoint.y - startingPoint.y;
    CGFloat vectorLength = sqrtf(powf(lengthX,2) + powf(lengthY,2));
    
    return CGPointMake(lengthX / vectorLength, lengthY / vectorLength);
}

CG_INLINE CGPoint
unitVector(CGPoint vector)
{
    CGFloat vectorLength = sqrtf(powf(vector.x,2) + powf(vector.y,2));
    return CGPointMake(vector.x / vectorLength, vector.y / vectorLength);
}

CG_INLINE CGPoint
vectorFromTo(CGPoint startingPoint, CGPoint endingPoint)
{
    CGFloat lengthX = endingPoint.x - startingPoint.x;
    CGFloat lengthY = endingPoint.y - startingPoint.y;
    
    return CGPointMake(lengthX, lengthY);
}

CG_INLINE CGPoint
vectorFromToLength(CGPoint startingPoint, CGPoint endingPoint, CGFloat length)
{
    CGFloat lengthX = endingPoint.x - startingPoint.x;
    CGFloat lengthY = endingPoint.y - startingPoint.y;
    CGFloat vectorLength = sqrtf(powf(lengthX,2) + powf(lengthY,2));
    
    return CGPointMake(length * lengthX / vectorLength, length * lengthY / vectorLength);
}

CG_INLINE CGPoint
vectorRotatedByAngleDegrees(CGPoint vector, CGFloat angleDegrees)
{
    CGFloat angleRadians = angleDegrees * M_PI / 180.0;
    CGFloat pointX = vector.x * cos(angleRadians) - vector.y * sin(angleRadians);
    CGFloat pointY = vector.x * sin(angleRadians) + vector.y * cos(angleRadians);
    
    return CGPointMake(pointX, pointY);
}

CG_INLINE CGPoint
unitNormalFromTo(CGPoint startingPoint, CGPoint endingPoint)
{
    CGFloat lengthX = endingPoint.x - startingPoint.x;
    CGFloat lengthY = endingPoint.y - startingPoint.y;
    CGFloat vectorLength = sqrtf(powf(lengthX,2) + powf(lengthY,2));
    
    return CGPointMake(lengthY / vectorLength, -lengthX / vectorLength);
}

CG_INLINE CGPoint
closestPointToPointForPoints(CGPoint referencePoint, NSArray *points)
{
    CGFloat closestDistance = -1.0;
    CGPoint closestPoint = CGPointZero;
    
    for (NSValue *v in points) {
        
        CGPoint testPoint = [v CGPointValue];
        CGFloat distanceToPoint = ccpDistance(testPoint, referencePoint);
        
        if (closestDistance < 0) {
            closestDistance = distanceToPoint;
            closestPoint = testPoint;
            continue;
        }
        
        if (distanceToPoint < closestDistance) {
            closestDistance = distanceToPoint;
            closestPoint = testPoint;
        }
    }
    return closestPoint;
}

#endif

//
//  BMPoint.h
//  Scorched
//
//  Created by Mark Kim on 3/30/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMPoint : BMModel
{
    BMDirectionType _neighborDirection;
}

@property (nonatomic, readonly) CGPoint point;
@property (nonatomic, readonly) BMDirectionType relativeDirection;

- (CGPoint)nextNeighbor;

+ (id)pointWithPoint:(CGPoint)point
       fromDirection:(BMDirectionType)directionType;
+ (id)pointWithPixelPoint:(CGPoint)pixelPoint
            fromDirection:(BMDirectionType)directionType;
- (id)initWithPoint:(CGPoint)point
      fromDirection:(BMDirectionType)directionType;
- (id)initWithPixelPoint:(CGPoint)pixelPoint
           fromDirection:(BMDirectionType)directionType;

@end

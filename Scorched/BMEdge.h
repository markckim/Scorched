//
//  BMEdge.h
//  Scorched
//
//  Created by Mark Kim on 3/16/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@interface BMEdge : BMViewModel

@property (nonatomic, readonly) CGPoint point1;
@property (nonatomic, readonly) CGPoint point2;

+ (id)edgeWithPoint1:(CGPoint)point1 point2:(CGPoint)point2;
+ (id)edgeWithPixelPoint1:(CGPoint)pixelPoint1 pixelPoint2:(CGPoint)pixelPoint2;
- (id)initEdgeWithPoint1:(CGPoint)point1 point2:(CGPoint)point2;
- (id)initEdgeWithPixelPoint1:(CGPoint)pixelPoint1 pixelPoint2:(CGPoint)pixelPoint2;

@end

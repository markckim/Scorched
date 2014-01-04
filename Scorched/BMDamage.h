//
//  BMDamage.h
//  Scorched
//
//  Created by Mark Kim on 3/18/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMDamage : BMModel

@property (nonatomic, readonly) CGPoint centerPoint;
@property (nonatomic, readonly) CGFloat radius;

+ (id)damageWithCenterPoint:(CGPoint)centerPoint
                     radius:(CGFloat)radius;
+ (id)damageWithCenterPixelPoint:(CGPoint)centerPixelPoint
                     pixelRadius:(CGFloat)pixelRadius;
- (id)initWithCenterPoint:(CGPoint)centerPoint
                   radius:(CGFloat)radius;
- (id)initWithCenterPixelPoint:(CGPoint)centerPixelPoint
                   pixelRadius:(CGFloat)pixelRadius;

@end

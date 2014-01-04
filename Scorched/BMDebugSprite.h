//
//  BMDebugSprite.h
//  Scorched
//
//  Created by Mark Kim on 5/4/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "CCSprite.h"

@interface BMDebugSprite : CCSprite

@property (nonatomic, retain) NSMutableArray *circleEdges;
@property (nonatomic, retain) NSArray *groundUnits;

- (void)createEdgesForCircleWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius;
- (id)initWithGroundUnits:(NSArray *)groundUnits;

@end

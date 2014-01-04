//
//  BMDebugView.h
//  Scorched
//
//  Created by Mark Kim on 3/13/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMWorldView.h"

@class BMDebugSprite;

@interface BMDebugView : BMWorldView

@property (nonatomic, retain) BMDebugSprite *debugSprite;

- (void)updateCircleEdgesMapWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius;
- (id)initWithGroundUnits:(NSArray *)groundUnits;

@end

//
//  BMDebugView.m
//  Scorched
//
//  Created by Mark Kim on 3/13/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMDebugView.h"
#import "BMDebugSprite.h"
#import "util_functions.h"

@implementation BMDebugView

- (void)dealloc
{
    [_debugSprite release]; _debugSprite = nil;
    [super dealloc];
}

- (void)updateCircleEdgesMapWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius
{
    if (_debugSprite.circleEdges && [_debugSprite.circleEdges count] > 0) {
        [_debugSprite.circleEdges removeAllObjects];
    }
    [_debugSprite createEdgesForCircleWithCenter:centerPoint radius:radius];
}

- (void)_setupDebugSprite
{
    _debugSprite.contentSize = self.view.contentSize;
    _debugSprite.position = ccp(0.5 * self.view.contentSize.width, 0.5 * self.view.contentSize.height);
}

- (id)initWithGroundUnits:(NSArray *)groundUnits
{
    if (self = [super init]) {
        _debugSprite = [[BMDebugSprite alloc] initWithGroundUnits:groundUnits];
        [self _setupDebugSprite];
        [self.view  addChild:_debugSprite z:99];
    }
    return self;
}

@end

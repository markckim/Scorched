//
//  BMTerrain.m
//  Scorched
//
//  Created by Mark Kim on 1/6/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMTerrain.h"

@implementation BMTerrain

- (void)dealloc
{
    [_stripes release]; _stripes = nil;
    
    [super dealloc];
}

- (void)setOffsetX:(float)newOffsetX
{
    _offsetX = newOffsetX;
    self.position = CGPointMake(-_offsetX * self.scale, 0);
}

- (void)generateHills
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float x = 0;
    float y = winSize.width / 2;
    for (int i = 0; i < kMaxHillKeyPoints; ++i) {
        _hillKeyPoints[i] = CGPointMake(x, y);
        x += winSize.width / 2;
        y = random() % (int) winSize.height;
    }
}

- (id)init
{
    if (self = [super init]) {
        [self generateHills];
    }
    return self;
}

- (void)draw
{
    for (int i = 1; i < kMaxHillKeyPoints; ++i) {
        ccDrawLine(_hillKeyPoints[i-1], _hillKeyPoints[i]);
    }
}

@end

















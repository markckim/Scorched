//
//  BMTerrain.h
//  Scorched
//
//  Created by Mark Kim on 1/6/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

#define kMaxHillKeyPoints 1000

@interface BMTerrain : BMModel
{
    int _offsetX;
    CGPoint _hillKeyPoints[kMaxHillKeyPoints];
    CCSprite *_stripes;
}

@property (nonatomic, retain) CCSprite *stripes;

- (void)setOffsetX:(float)newOffsetX;

@end

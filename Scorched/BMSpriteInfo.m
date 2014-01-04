//
//  BMSpriteInfo.m
//  Scorched
//
//  Created by Mark Kim on 5/5/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMSpriteInfo.h"

@interface BMSpriteInfo ()

- (void)_setupView;

@end

@implementation BMSpriteInfo

- (void)_setupView
{
    NSAssert(self.view, @"view is not set!");
    // note: setting position to bottom left corner in preparation for reading the texture later in BMGround
    self.view.position = ccp(0.5 * self.view.contentSize.width, 0.5 * self.view.contentSize.height);
}

- (id)initWithView:(CCSprite *)view finalPosition:(CGPoint)finalPosition
{
    if (self = [super initWithView:view]) {
        _finalPosition = finalPosition;
        [self _setupView];
    }
    return self;
}

@end

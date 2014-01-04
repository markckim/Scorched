//
//  BMWorldView.m
//  Scorched
//
//  Created by Mark Kim on 5/4/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMWorldView.h"

@interface BMWorldView ()

- (void)_setupView;

@end

@implementation BMWorldView

- (void)dealloc
{
    [_view release]; _view = nil;
    [super dealloc];
}

- (void)_setupView
{
    // TODO: - Mark Kim - need to stop using TEST_IMAGE_SIZE constant and have the controller give it to this view
    _view.contentSize = TEST_IMAGE_SIZE;
    _view.position = ccp(0.5 * _view.contentSize.width, 0.5 * _view.contentSize.height);
}

- (id)init
{
    if (self = [super init]) {
        _view = [[CCSprite alloc] init];
        [self _setupView];
        [self addChild:_view z:0];
    }
    return self;
}

@end

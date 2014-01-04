//
//  BMHealthBar.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMHealthBar.h"
#import "BMView.h"

@implementation BMHealthBar

- (void)dealloc
{
    _delegate = nil;
    
    [_backSprite release]; _backSprite = nil;
    [_frontSprite release]; _frontSprite = nil;
    
    [super dealloc];
}

- (void)updateView
{
    int currentHealth = _delegate.currentHealth;
    int maxHealth = _delegate.maxHealth;
    
    CGFloat percentHealth = (CGFloat)currentHealth / (CGFloat)maxHealth;
    
    // TODO: show updated health bar
}

- (void)_initView
{
    self.view.contentSize = _backSprite.contentSize;
    _backSprite.position = ccp(self.view.contentSize.width/2, self.view.contentSize.width/2);
    _frontSprite.position = ccp(self.view.contentSize.width/2, self.view.contentSize.width/2);
}

- (id)init
{
    if (self = [super init])
    {
        _delegate = nil;
        _backSprite = [[CCSprite alloc] init];
        _frontSprite = [[CCSprite alloc] init];
    }
    return self;
}

- (id)initWithDelegate:(id<BMHealthBarDelegate>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        _backSprite = [[CCSprite alloc] init];
        _frontSprite = [[CCSprite alloc] init];
    }
    return self;
}

- (id)initWithDelegate:(id<BMHealthBarDelegate>)delegate
            backSprite:(CCSprite *)backSprite
           frontSprite:(CCSprite *)frontSprite;
{
    if (self = [super init]) {
        _delegate = delegate;
        _backSprite = [backSprite retain];
        _frontSprite = [frontSprite retain];
        
        [self _initView];
        
        [self.view addChild:_backSprite z:0];
        [self.view addChild:_frontSprite z:1];
    }
    return self;
}

@end













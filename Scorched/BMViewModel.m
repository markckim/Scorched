//
//  BMViewModel.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"
#import "BMView.h"

@implementation BMViewModel

- (void)dealloc
{
    [_view release]; _view = nil;
    [super dealloc];
}

- (void)cleanup
{
    [super cleanup];
}

- (id)initWithView:(CCSprite *)view
{
    if (self = [super init]) {
        _view = [view retain];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        _view = [[CCSprite alloc] init];
    }
    return self;
}

@end

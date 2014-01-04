//
//  BMNameLabel.m
//  Scorched
//
//  Created by Mark Kim on 1/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMNameLabel.h"

@implementation BMNameLabel

- (void)dealloc
{
    [_name release]; _name = nil;
    [super dealloc];
}

- (void)_initView
{
    
}

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = [name copy];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        _name = [@"default" copy];
    }
    return self;
}

@end

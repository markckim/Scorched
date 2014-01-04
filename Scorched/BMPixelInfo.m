//
//  BMPixelInfo.m
//  Scorched
//
//  Created by Mark Kim on 4/10/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMPixelInfo.h"

@implementation BMPixelInfo

+ (id)info
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init]) {
        _isClear = YES;
        _isSurface = NO;
    }
    return self;
}

@end

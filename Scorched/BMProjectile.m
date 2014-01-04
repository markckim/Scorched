//
//  BMProjectile.m
//  Scorched
//
//  Created by Mark Kim on 12/4/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMProjectile.h"

@implementation BMProjectile


- (id)init
{
    if (self = [super init])
    {
        _damage = 10;
        
        self.modelType = kProjectileModel;
    }
    return self;
}

@end

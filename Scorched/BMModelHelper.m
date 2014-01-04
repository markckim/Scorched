//
//  BMModelHelper.m
//  Scorched
//
//  Created by Mark Kim on 12/5/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModelHelper.h"
#import "BMPlayer.h"
#import "BMProjectile.h"

@implementation BMModelHelper

+ (Class)getClassForModelType:(BMModelType)modelType
{
    NSString *modelClassString = nil;
    
    switch (modelType)
    {
        case kProjectileModel:
            modelClassString = @"BMProjectile";
            break;
            
        case kPlayerModel:
            modelClassString = @"BMPlayer";
            break;
            
        default:
            modelClassString = @"BMModel";
            break;
    }
    
    return NSClassFromString(modelClassString);
}

@end



















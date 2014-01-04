//
//  BMServiceHelper.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMServiceHelper.h"

@implementation BMServiceHelper

+ (NSString *)getPathForAPIMessageType:(BMAPIMessageType)messageType
{
    NSString *pathString = nil;
    
    switch (messageType)
    {
        case kAPIMessageTypeLogin:
            pathString = LOGIN_PATH;
            break;
            
        default:
            break;
    }
    
    return pathString;
}

@end

//
//  BMServiceHelper.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"
#import "server_constants.h"

@interface BMServiceHelper : BMModel

+ (NSString *)getPathForAPIMessageType:(BMAPIMessageType)messageType;

@end

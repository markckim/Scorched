//
//  BMServiceManager.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMServiceManager.h"
#import "BMCommand.h"
#import "ASIFormDataRequest.h"
#import "BMServiceHelper.h"
#import "server_constants.h"

@implementation BMServiceManager

- (void)sendRequestWithCommand:(BMCommand *)command
{
    NSAssert(command.messageType != 0, @"command.messageType should not be 0");
    NSAssert(command.delegate != nil, @"command.delegate should not be nil");
    NSAssert(command.parameters != nil, @"command.parameters should not be nil");
    NSAssert(command.didFinishSelector != nil, @"command.didFinishSelector should not be nil");
    NSAssert(command.didFailSelector != nil, @"command.didFailSelector should not be nil");
    
    NSString *subPathString = [BMServiceHelper getPathForAPIMessageType:command.messageType];
    NSString *requestPathString = [NSString stringWithFormat:@"%@%@", BASE_URL, subPathString];
    NSURL *requestPathURL = [NSURL URLWithString:requestPathString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestPathURL];
    request.delegate = command.delegate;
    request.didFinishSelector = command.didFinishSelector;
    request.didFailSelector = command.didFailSelector;
    
    [command.parameters enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                                usingBlock:^(id key, id obj, BOOL *stop) {
                                                    [request setPostValue:obj forKey:key];
                                                }
     ];
    
    [request startAsynchronous];
}

- (void)sendWebSocketRequestWithCommand:(BMWebSocketCommand *)command
{
    CCLOG(@"empty method called");
    // do stuff
}

+ (BMServiceManager *)sharedInstance
{
    static BMServiceManager *sharedManager;
    
    @synchronized(self)
    {
        if (!sharedManager) {
            sharedManager = [[BMServiceManager alloc] init];
        }
        return sharedManager;
    }
}

@end

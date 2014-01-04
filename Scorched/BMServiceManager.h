//
//  BMServiceManager.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMCommand;
@class BMWebSocketCommand;

@interface BMServiceManager : NSObject

+ (BMServiceManager *)sharedInstance;

- (void)sendRequestWithCommand:(BMCommand *)command;

// TODO: - Mark Kim - need to create BMWebSocketCommand; need to implement this method
- (void)sendWebSocketRequestWithCommand:(BMWebSocketCommand *)command;

@end

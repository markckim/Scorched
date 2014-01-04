//
//  BMScene.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BMExtensions.h"
#import "BMGameManager.h"
#import "BMSceneManager.h"
#import "JSONKit.h"
#import "cocos2d.h"
#import "game_constants.h"
#import "game_protocols.h"
#import "server_constants.h"

@interface BMController : CCScene

@property BMSceneType sceneTypeId;

// TODO: - Mark Kim - for testing purposes; remove later
- (CCMenuItemFont *)addBackButtonToGateway;

@end

//
//  BMSceneManager.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "game_constants.h"
#import "cocos2d.h"

@interface BMSceneManager : NSObject
{
    BMSceneType _currentSceneType;
}

+ (BMSceneManager *)sharedInstance;

- (void)runSceneWithSceneType:(BMSceneType)sceneId;
- (void)pushSceneWithSceneType:(BMSceneType)sceneId;

@end

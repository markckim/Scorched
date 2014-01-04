//
//  BMSceneManager.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMSceneManager.h"
#import "BMSplashController.h"
#import "BMGameController.h"
#import "BMMenuController.h"
#import "BMTestController.h"
#import "BMGatewayController.h"

@implementation BMSceneManager

- (void)dealloc
{    
    [super dealloc];
}

- (void)runSceneWithSceneType:(BMSceneType)sceneType
{
    BMSceneType oldSceneType = _currentSceneType;
    id sceneToRun = nil;
    
    switch (sceneType)
    {
        case kSplashScene:
            sceneToRun = [BMSplashController node];
            break;
            
        case kGatewayScene:
            sceneToRun = [BMGatewayController node];
            break;
            
        case kMenuScene:
            sceneToRun = [BMMenuController node];
            break;
            
        case kGameScene:
            sceneToRun = [BMGameController node];
            break;
            
        case kTestScene:
            sceneToRun = [BMTestController node];
            break;
            
        default:
            CCLOG(@"unrecognized scene to run");
            break;
    }
    
    if (!sceneToRun) {
        _currentSceneType = oldSceneType;
        return;
    }
    
    if (![[CCDirector sharedDirector] runningScene]) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    }
    else {
        [[CCDirector sharedDirector] replaceScene: sceneToRun];
    }
    
    _currentSceneType = sceneType;
}

// TODO: - Mark Kim - fix this eventually when I need it; currently doesn't work
- (void)pushSceneWithSceneType:(BMSceneType)sceneType
{
    id sceneToRun = nil;
    
    switch (sceneType)
    {
        case kGameScene:
            sceneToRun = nil;
            break;
            
        default:
            CCLOG(@"unrecognized scene to push");
            break;
    }
    
    [[CCDirector sharedDirector] pushScene:sceneToRun];
}

+ (BMSceneManager *)sharedInstance
{
    static BMSceneManager *sharedManager;
    
    @synchronized(self)
    {
        if (!sharedManager) {
            sharedManager = [[BMSceneManager alloc] init];
        }
        return sharedManager;
    }
}

@end

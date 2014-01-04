//
//  BMGatewayController.m
//  Scorched
//
//  Created by Mark Kim on 1/1/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMGatewayController.h"

@implementation BMGatewayController

- (void)_addMenu
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:14];
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"menu scene"
                                                         block:^(id sender) {
                                                             [self _menuScene];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:@"game scene"
                                                         block:^(id sender) {
                                                             [self _gameScene];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem3 = [CCMenuItemFont itemWithString:@"test scene"
                                                         block:^(id sender) {
                                                             [self _testScene];
                                                         }
                                 ];
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    menu.position = ccp(winSize.width / 2, winSize.height / 2);
    [menu alignItemsVerticallyWithPadding:10.0];
    
    [self addChild:menu];
}

- (void)_menuScene
{
    [[BMSceneManager sharedInstance] runSceneWithSceneType:kMenuScene];
}

- (void)_gameScene
{
    [[BMSceneManager sharedInstance] runSceneWithSceneType:kGameScene];
}

- (void)_testScene
{
    [[BMSceneManager sharedInstance] runSceneWithSceneType:kTestScene];
}

- (id)init
{
    if (self = [super init]) {
        
        self.sceneTypeId = kGatewayScene;
        
        [self _addMenu];
    }
    return self;
}

@end

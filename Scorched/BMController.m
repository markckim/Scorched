//
//  BMScene.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright 2012 Mark Kim. All rights reserved.
//

#import "BMController.h"

@implementation BMController

- (CCMenuItemFont *)addBackButtonToGateway
{
    if (self.sceneTypeId == kSplashScene || self.sceneTypeId == kGatewayScene) {
        return nil;
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:14];
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"back"
                                                         block:^(id sender) {
                                                             [self _gatewayScene];
                                                         }
                                 ];
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
    menu.position = ccp(0.05 * winSize.width, 0.95 * winSize.height);
    
    [self addChild:menu z:999];
    return menuItem1;
}

- (void)_gatewayScene
{
    [[BMSceneManager sharedInstance] runSceneWithSceneType:kGatewayScene];
}

- (void)dealloc
{    
    [super dealloc];
}

@end

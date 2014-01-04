//
//  BMSplashView.m
//  Scorched
//
//  Created by Mark Kim on 12/27/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMSplashView.h"

@implementation BMSplashView

- (id)init
{
    if (self = [super init]) {
                
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
		
		[self addChild:background];
    }
    return self;
}

@end

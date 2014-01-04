//
//  IntroLayer.h
//  Scorched
//
//  Created by Mark Kim on 11/24/12.
//  Copyright Mark Kim 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "ASIHTTPRequestDelegate.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer <ASIHTTPRequestDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

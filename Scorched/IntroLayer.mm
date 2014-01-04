//
//  IntroLayer.m
//  Scorched
//
//  Created by Mark Kim on 11/24/12.
//  Copyright Mark Kim 2012. All rights reserved.
//

#import "IntroLayer.h"
#import "TestLayer.h"
#import "BMGameController.h"
#import "NSString+BMExtensions.h"
#import "BMCommand.h"
#import "JSONKit.h"
#import "server_constants.h"

#import "TestObject.h"

#pragma mark - IntroLayer

@interface IntroLayer ()
- (void)_requestLogin;
@end

@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)_requestLogin
{
    NSString *deviceType = @"iphone";
    NSString *deviceId = @"ben";
    NSString *secret = [[NSString stringWithFormat:@"%@%@", deviceId, SECRET_KEY] md5];
    
    BMCommand *command = [BMCommand commandWithDelegate:self];
    command.messageType = kAPIMessageTypeLogin;
    command.didFinishSelector = @selector(didFinishLoginWithRequest:);
    command.didFailSelector = @selector(didFailLoginWithRequest:);
    command.parameters = @{
        @"device_type"  : deviceType,
        @"device_id"    : deviceId,
        @"secret"       : secret,
    };
    [command send];
}

- (void)didFinishLoginWithRequest:(ASIHTTPRequest *)request
{
    CCLOG(@"didFinishLoginWithRequest:");
    
    NSString *jsonString = request.responseString;
    NSDictionary *dict = [jsonString objectFromJSONString];
    
    
    
    
}

- (void)didFailLoginWithRequest:(ASIHTTPRequest *)request
{
    CCLOG(@"didFailLoginWithRequest:");
}

-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
        
        // make login request
        [self _requestLogin];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BMGameController node] ]];
}
@end

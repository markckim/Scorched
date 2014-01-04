//
//  BMSplashController.m
//  Scorched
//
//  Created by Mark Kim on 12/27/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "BMSplashController.h"
#import "BMSplashView.h"
#import "BMCommand.h"
#import "BMGatewayController.h"

@interface BMSplashController ()
- (void)_requestLogin;
@end

@implementation BMSplashController

-(void) onEnter
{    
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.5 scene:[BMGatewayController node] ]];
}

- (void)dealloc
{
    [_view release]; _view = nil;
    
    [super dealloc];
}

- (void)_requestLogin
{
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *deviceId = [BMGameManager sharedInstance].uuid;
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
    NSDictionary *dictionary = [jsonString objectFromJSONString];
    
    [[BMGameManager sharedInstance] syncPlayerWithDictionary:dictionary];
}

- (void)didFailLoginWithRequest:(ASIHTTPRequest *)request
{
    CCLOG(@"didFailLoginWithRequest:");
}

- (id)init
{
    if (self = [super init]) {
        
        self.sceneTypeId = kSplashScene;
        
        _view = [[BMSplashView alloc] init];
        [self addChild:_view];
        [self _requestLogin];
    }
    return self;
}

@end

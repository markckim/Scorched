//
//  BMMenuController.m
//  Scorched
//
//  Created by Mark Kim on 12/27/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMMenuController.h"
#import "BMMenuView.h"
#import "BMGameManager.h"
#import "BMPlayer.h"
#import "BMPlayerInfo.h"
#import "JSONKit.h"

@interface BMMenuController ()
- (void)_reconnect;
@end

@implementation BMMenuController

- (void)dealloc
{
    [_view release]; _view = nil;
    [_menu release]; _menu = nil;
    [_statusLabel release]; _statusLabel = nil;
    [_webSocket release]; _webSocket = nil;
    [super dealloc];
}

- (CCMenu *)_getMenu
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:18];
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"[step 1] reconnect"
                                                         block:^(id sender) {
                                                             [self _reconnect];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:@"[step 2] authenticate"
                                                         block:^(id sender) {
                                                             [self _authenticate];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem3 = [CCMenuItemFont itemWithString:@"[step 3] join game"
                                                         block:^(id sender) {
                                                             [self _joinGame];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem4 = [CCMenuItemFont itemWithString:@"[step 4] choose game"
                                                         block:^(id sender) {
                                                             [self _chooseGame];
                                                         }
                                 ];
    

    
    CCMenuItemFont *menuItem5 = [CCMenuItemFont itemWithString:@"[action] fire shot"
                                                         block:^(id sender) {
                                                             [self _fireShot];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem6 = [CCMenuItemFont itemWithString:@"[action] acknowledge"
                                                         block:^(id sender) {
                                                             [self _acknowledge];
                                                         }
                                 ];
    
    CCMenuItemFont *menuItem7 = [CCMenuItemFont itemWithString:@"[action] pass"
                                                         block:^(id sender) {
                                                             [self _pass];
                                                         }
                                 ];
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6, menuItem7, nil];
    [menu alignItemsVerticallyWithPadding:10];
    menu.position = ccp(winSize.width/2, winSize.height/2);
    
    return menu;
}

- (void)_reconnect
{
    _statusLabel.string = @"...";
    
    [_webSocket closeWithCode:1000 reason:nil];
    
    NSURL *url = [NSURL URLWithString:@"ws://127.0.0.1:8080/ws"];
    [_webSocket release];
    _webSocket = [[SRWebSocket alloc] initWithURL:url];
    _webSocket.delegate = self;
    
    [_webSocket open];
}

- (void)_authenticate
{
//    send({'type':AUTHENTICATE, 'session_key':player_info['session_key'], 'uid':uid})
    _statusLabel.string = @"...";
    
    BMPlayerInfo *playerInfo = [BMGameManager sharedInstance].player.playerInfo;
    NSString *sessionKey = playerInfo.sessionKey;
    NSString *uid = playerInfo.playerId;
   
    //Authentication_Builder *authBuilder = [[Authentication_Builder alloc] init];
    //[authBuilder setToken:@"testtoken"];
    //[authBuilder setUid:1];
    //[authBuilder setUid:uid.intValue];
    //Authentication* authenticationRequest = [authBuilder build];
    //NSData *authData = [authenticationRequest data];
    //uint8_t val = TypesAuthentication;
    //NSMutableData *data = [NSMutableData dataWithBytes:&val length:1];
    //[data appendData:authData];
    //[_webSocket send:data];
    CCLOG(@"sent auth request");
}

- (void)_chooseGame
{
//    send({'type':CLIENT_CHOOSE_GAME, 'game_type':GAME_TYPE_1_ON_1})
    _statusLabel.string = @"...";
    
    BMPlayerInfo *playerInfo = [BMGameManager sharedInstance].player.playerInfo;
    NSString *sessionKey = playerInfo.sessionKey;
    
    NSDictionary *dict = @{
    @"type"         : [NSNumber numberWithInt:CLIENT_CHOOSE_GAME],
    @"session_key"  : sessionKey,
    @"game_type"    : [NSNumber numberWithInt:GAME_TYPE_1_ON_1],
    };
    
    NSString *jsonString = [dict JSONString];
    
    [_webSocket send:jsonString];
}

- (void)_fireShot
{
//    send({'type':CLIENT_FIRED})
//    _statusLabel.string = @"...";
//    
//    Attack_Builder *attackBuilder = [[Attack_Builder alloc] init];
//    [attackBuilder setType:Attack_AttackTypeBasic];
//    [attackBuilder setAngle:60.0];
//    [attackBuilder setVelocity:30];
//    Attack* attackRequest = [attackBuilder build];
//    NSData *authData = [attackRequest data];
//    uint8_t val = TypesAttack;
//    NSMutableData *data = [NSMutableData dataWithBytes:&val length:1];
//    [data appendData:authData];
//    [_webSocket send:data];
    
}

- (void)_joinGame
{
    _statusLabel.string = @"...";
    
//    JoinGame_Builder *joinGameBuilder = [[JoinGame_Builder alloc] init];
//    [joinGameBuilder setGameId: 9];
//    [joinGameBuilder setUid: 1];
//    JoinGame* joinGameRequest = [joinGameBuilder build];
//    NSData *requestData = [joinGameRequest data];
//    uint8_t val = TypesJoinGame;
//    NSMutableData *data = [NSMutableData dataWithBytes:&val length:1];
//    [data appendData:requestData];
//    [_webSocket send:data];
    
}

- (void)_pass
{
//    send({'type':CLIENT_PASS})
    _statusLabel.string = @"...";

    BMPlayerInfo *playerInfo = [BMGameManager sharedInstance].player.playerInfo;
    NSString *sessionKey = playerInfo.sessionKey;
    
    NSDictionary *dict = @{
    @"type"         : [NSNumber numberWithInt:CLIENT_PASS],
    @"session_key"  : sessionKey,
    };
    
    NSString *jsonString = [dict JSONString];
    
    [_webSocket send:jsonString];
}

- (void)_acknowledge
{
//    send({'type':CLIENT_ACK_ACTION})
    _statusLabel.string = @"...";

    BMPlayerInfo *playerInfo = [BMGameManager sharedInstance].player.playerInfo;
    NSString *sessionKey = playerInfo.sessionKey;
    
    NSDictionary *dict = @{
    @"type"         : [NSNumber numberWithInt:CLIENT_ACK_ACTION],
    @"session_key"  : sessionKey,
    };
    
    NSString *jsonString = [dict JSONString];
    
    [_webSocket send:jsonString];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    CCLOG(@"webSocket:didReceiveMessage: %@", message);
    
    
    CCLOG(@"message from server: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    CCLOG(@"webSocketDidOpen:");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    CCLOG(@"webSocket:didFailWithError:");
    CCLOG(@"error: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    CCLOG(@"webSocket:didCloseWithCode:reason:wasClean:");
    CCLOG(@"code: %d", code);
}

- (id)init
{
    if (self = [super init]) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        self.sceneTypeId = kMenuScene;
        
        _view = [[BMMenuView alloc] init];
        
        _statusLabel = [[CCLabelBMFont alloc] initWithString:@"..."
                                                     fntFile:@"MushroomTextMedium.fnt"
                                                       width:400
                                                   alignment:kCCTextAlignmentCenter];
        _statusLabel.position = ccp(0.5 * winSize.width, 0.9 * winSize.height);
        
        _menu = [[self _getMenu] retain];
        
        [self addBackButtonToGateway];
        [self addChild:_view z:0];
        [self addChild:_statusLabel z:1];
        [self addChild:_menu z:2];
    }
    return self;
}

@end























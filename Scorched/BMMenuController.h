//
//  BMMenuController.h
//  Scorched
//
//  Created by Mark Kim on 12/27/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMController.h"
#import "SRWebSocket.h"

@class BMMenuView;

@interface BMMenuController : BMController <SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
}

@property (nonatomic, retain) BMMenuView *view;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCLabelBMFont *statusLabel;

// SRWebSocketDelegate methods
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end


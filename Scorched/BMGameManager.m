//
//  BMGameManager.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMGameManager.h"
#import "BMPlayer.h"
#import "BMPlayerInfo.h"
#import "BMDevice.h"
#import "BMHero.h"

@implementation BMGameManager

- (void)syncPlayerWithDictionary:(NSDictionary *)dictionary
{
    CCLOG(@"syncPlayerWithDictionary:");
    self.player = [[[BMPlayer alloc] initWithDictionary:dictionary] autorelease];
    
    // testing
    BMDevice *device = [_player.playerInfo.devices objectAtIndex:0];
    CCLOG(@"device id: %@, type: %@", device.deviceId, device.deviceType);
}

+ (BMGameManager *)sharedInstance
{
    static BMGameManager *sharedManager;
    
    @synchronized(self)
    {
        if (!sharedManager) {
            sharedManager = [[BMGameManager alloc] init];
            sharedManager.uuid = [[NSUUID UUID] UUIDString];
            sharedManager.hero = [[BMHero alloc] init];
            sharedManager.player = [[BMPlayer alloc] init];
        }
        return sharedManager;
    }
}

@end

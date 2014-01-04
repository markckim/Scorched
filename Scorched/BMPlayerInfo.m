//
//  BMPlayerInfo.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMPlayerInfo.h"
#import "BMDevice.h"

@implementation BMPlayerInfo

- (void)dealloc
{
    [_firstName release]; _firstName = nil;
    [_lastName release]; _lastName = nil;
    [_userName release]; _userName = nil;
    [_lastLogout release]; _lastLogout = nil;
    [_lastLogin release]; _lastLogin = nil;
    [_socialNetworkId release]; _socialNetworkId = nil;
    [_sessionKey release]; _sessionKey = nil;
    [_playerId release]; _playerId = nil;
    [_password release]; _password = nil;
    [_email release]; _email = nil;
    [_devices release]; _devices = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        
        // TODO: - Mark Kim - for testing; remove later
        int randomInt = arc4random() % 99999;
        _userName = [[NSString stringWithFormat:@"user%d", randomInt] copy];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        _firstName = [[dictionary objectForKey:@"first_name"] copy];
        _lastName = [[dictionary objectForKey:@"last_name"] copy];
        
        
        // TODO: - Mark Kim - for testing; remove later
        //_userName = [[dictionary objectForKey:@"user_name"] copy];
        if (!_userName) {
            int randomInt = arc4random() % 99999;
            _userName = [[NSString stringWithFormat:@"user%d", randomInt] copy];
        }
        
        _lastLogout = [[dictionary objectForKey:@"last_logout"] copy];
        _lastLogin = [[dictionary objectForKey:@"last_login"] copy];
        _socialNetworkId = [[dictionary objectForKey:@"social_network_id"] copy];
        _sessionKey = [[dictionary objectForKey:@"session_key"] copy];
        _playerId = [[dictionary objectForKey:@"id"] copy];
        _password = [[dictionary objectForKey:@"password"] copy];
        _email = [[dictionary objectForKey:@"email"] copy];
        
        _devices = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in [dictionary objectForKey:@"devices"]) {
            BMDevice *device = [[[BMDevice alloc] initWithDictionary:dict] autorelease];
            [_devices addObject:device];
        }
        
        _wins = [[dictionary objectForKey:@"wins"] intValue];
        _losses = [[dictionary objectForKey:@"losses"] intValue];
        _rating = [[dictionary objectForKey:@"rating"] intValue];
        _xp = [[dictionary objectForKey:@"xp"] intValue];
        _coins = [[dictionary objectForKey:@"coins"] intValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dictionary setObject:_firstName forKey:@"first_name"];
    [dictionary setObject:_lastName forKey:@"last_name"];
    [dictionary setObject:_userName forKey:@"user_name"];
    [dictionary setObject:_lastLogout forKey:@"last_logout"];
    [dictionary setObject:_lastLogin forKey:@"last_login"];
    [dictionary setObject:_socialNetworkId forKey:@"social_network_id"];
    [dictionary setObject:_sessionKey forKey:@"session_key"];
    [dictionary setObject:_playerId forKey:@"id"];
    [dictionary setObject:_password forKey:@"password"];
    [dictionary setObject:_email forKey:@"email"];
    
    NSMutableArray *devicesArray = [NSMutableArray array];
    for (BMDevice *device in _devices) {
        [devicesArray addObject:[device dictionary]];
    }
    [dictionary setObject:devicesArray forKey:@"devices"];
    
    [dictionary setObject:[NSNumber numberWithInt:_wins] forKey:@"wins"];
    [dictionary setObject:[NSNumber numberWithInt:_losses] forKey:@"losses"];
    [dictionary setObject:[NSNumber numberWithInt:_rating] forKey:@"rating"];
    [dictionary setObject:[NSNumber numberWithInt:_xp] forKey:@"xp"];
    [dictionary setObject:[NSNumber numberWithInt:_coins] forKey:@"coins"];
    
    return dictionary;
}

@end














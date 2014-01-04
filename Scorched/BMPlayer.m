//
//  BMPlayer.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMPlayer.h"
#import "BMAvatar.h"
#import "BMVehicle.h"
#import "BMPlayerInfo.h"

@implementation BMPlayer

- (void)dealloc
{
    [_playerInfo release]; _playerInfo = nil;
    [_avatars release]; _avatars = nil;
    [_vehicles release]; _vehicles = nil;
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        _playerInfo = [[BMPlayerInfo alloc] initWithDictionary:[dictionary objectForKey:@"player_info"]];
        
        _avatars = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in [dictionary objectForKey:@"avatars"]) {
            BMAvatar *avatar = [[[BMAvatar alloc] initWithDictionary:dict] autorelease];
            [_avatars addObject:avatar];
        }
        
        _vehicles = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in [dictionary objectForKey:@"vehicles"]) {
            BMVehicle *vehicle = [[[BMVehicle alloc] initWithDictionary:dict] autorelease];
            [_vehicles addObject:vehicle];
        }
        
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dictionary setObject:[_playerInfo dictionary] forKey:@"player_info"];
    
    NSMutableArray *avatarsArray = [NSMutableArray array];
    for (BMAvatar *avatar in _avatars) {
        [avatarsArray addObject:[avatar dictionary]];
    }
    [dictionary setObject:avatarsArray forKey:@"avatars"];
    
    NSMutableArray *vehiclesArray = [NSMutableArray array];
    for (BMVehicle *vehicle in _vehicles) {
        [vehiclesArray addObject:[vehicle dictionary]];
    }
    [dictionary setObject:vehiclesArray forKey:@"vehicles"];
    
    return dictionary;
}

- (id)init
{
    if (self = [super init]) {
        
        _playerInfo = [[BMPlayerInfo alloc] init];
        _avatars = [[NSMutableArray alloc] init];
        _vehicles = [[NSMutableArray alloc] init];
        
        self.modelType = kPlayerModel;
    }
    return self;
}

@end
















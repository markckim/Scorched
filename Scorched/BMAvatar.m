//
//  BMAvatar.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMAvatar.h"

@implementation BMAvatar

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        _avatarType = [[dictionary objectForKey:@"avatar_type"] intValue];
        _stamina = [[dictionary objectForKey:@"stamina"] intValue];
        _intelligence = [[dictionary objectForKey:@"intelligence"] intValue];
        _strength = [[dictionary objectForKey:@"strength"] intValue];
        _agility = [[dictionary objectForKey:@"agility"] intValue];
        _energy = [[dictionary objectForKey:@"energy"] intValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dictionary setObject:[NSNumber numberWithInt:_avatarType] forKey:@"avatar_type"];
    [dictionary setObject:[NSNumber numberWithInt:_stamina] forKey:@"stamina"];
    [dictionary setObject:[NSNumber numberWithInt:_intelligence] forKey:@"intelligence"];
    [dictionary setObject:[NSNumber numberWithInt:_strength] forKey:@"strength"];
    [dictionary setObject:[NSNumber numberWithInt:_agility] forKey:@"agility"];
    [dictionary setObject:[NSNumber numberWithInt:_energy] forKey:@"energy"];
    
    return dictionary;
}

- (id)init
{
    if (self = [super init]) {
        _avatarType = kAvatarDefault;
        _stamina = 3;
        _intelligence = 3;
        _strength = 3;
        _agility = 3;
        _energy = 3;
    }
    return self;
}

@end

//
//  BMHero.m
//  Scorched
//
//  Created by Mark Kim on 1/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMHero.h"
#import "BMNameLabel.h"
#import "BMHealthBar.h"
#import "BMAvatar.h"
#import "BMVehicle.h"
#import "BMAvatarHelper.h"

@implementation BMHero

- (void)dealloc
{
    [_nameLabel release]; _nameLabel = nil;
    [_healthBar release]; _healthBar = nil;
    [_avatar release]; _avatar = nil;
    [_vehicle release]; _vehicle = nil;
    
    [super dealloc];
}

// overriding setter for _currentHealth
- (void)setCurrentHealth:(int)currentHealth
{
    _currentHealth = currentHealth;
    [_healthBar updateView];
}

- (id)init
{
    if (self = [super init]) {
        
        self.modelType = kHeroModel;
        
        _nameLabel = [[BMNameLabel alloc] init];
        _healthBar = [[BMHealthBar alloc] initWithDelegate:self];
        _avatar = [[BMAvatar alloc] init];
        _vehicle = [[BMVehicle alloc] init];
        _maxHealth = [BMAvatarHelper healthForStamina:_avatar.stamina];
        _currentHealth = [BMAvatarHelper healthForStamina:_avatar.stamina];
    }
    return self;
}

@end

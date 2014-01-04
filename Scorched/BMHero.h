//
//  BMHero.h
//  Scorched
//
//  Created by Mark Kim on 1/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@class BMAvatar;
@class BMVehicle;
@class BMHealthBar;
@class BMNameLabel;

@interface BMHero : BMViewModel <BMHealthBarDelegate>

@property (nonatomic, retain) BMNameLabel *nameLabel;
@property (nonatomic, retain) BMHealthBar *healthBar;
@property (nonatomic, retain) BMAvatar *avatar;
@property (nonatomic, retain) BMVehicle *vehicle;
@property (nonatomic, assign) int currentHealth;
@property (nonatomic, assign) int maxHealth;

@end

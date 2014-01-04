//
//  BMAvatar.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@class BMView;

@interface BMAvatar : BMViewModel

@property (nonatomic, assign) BMAvatarType avatarType;
@property (nonatomic, assign) int stamina;
@property (nonatomic, assign) int intelligence;
@property (nonatomic, assign) int strength;
@property (nonatomic, assign) int agility;
@property (nonatomic, assign) int energy;

@end

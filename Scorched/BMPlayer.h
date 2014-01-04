//
//  BMPlayer.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@class BMPlayerInfo;

@interface BMPlayer : BMModel

@property (nonatomic, retain) BMPlayerInfo      *playerInfo;
@property (nonatomic, retain) NSMutableArray    *avatars;
@property (nonatomic, retain) NSMutableArray    *vehicles;

@end

//
//  BMProjectile.h
//  Scorched
//
//  Created by Mark Kim on 12/4/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@interface BMProjectile : BMViewModel

@property (nonatomic, assign) int damage;
@property (nonatomic, assign) CGPoint touchLocation;

@end

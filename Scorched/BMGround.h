//
//  BMGround.h
//  Scorched
//
//  Created by Mark Kim on 3/5/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@class BMDamage;
@class BMSpriteInfo;

@interface BMGround : BMViewModel

@property (nonatomic, copy) NSString *key; // can be used to keep track of BMGround
@property (nonatomic, readonly) NSMutableArray *edgePoints;

- (CGFloat)reload; // will return duration of caculation in seconds for debugging
- (void)removeGroundWithDamage:(BMDamage *)damage;
- (void)logColorForPoint:(CGPoint)touchPoint; // for debugging only
+ (id)groundWithDelegate:(id<BMGroundDelegate>)delegate viewInfo:(BMSpriteInfo *)viewInfo;
- (id)initWithDelegate:(id<BMGroundDelegate>)delegate viewInfo:(BMSpriteInfo *)viewInfo;

@end

//
//  BMPhysics.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"
#import "BMContactListener.h"
#import "Box2D.h"
#import <map>
#import <string>

@class BMDamage;
@class BMGround;
@class BMPhysicsParameters;
@protocol BMPhysicsDelegate;

@interface BMPhysics : BMModel <BMGroundDelegate>

@property (nonatomic, readonly) NSMutableArray *groundUnits;

- (void)queueDamage:(BMDamage *)damage;
- (void)queueBodyWithParameters:(BMPhysicsParameters *)params;
- (void)queueBodyToDestroy:(b2Body *)body;
- (id)initWithDelegate:(id<BMPhysicsDelegate>)delegate spritesInfo:(NSArray *)spritesInfo;

@end

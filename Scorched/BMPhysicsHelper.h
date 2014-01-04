//
//  BMPhysicsHelper.h
//  Scorched
//
//  Created by Mark Kim on 3/17/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@class BMDebugModel;
@class BMViewModel;
@class BMPhysicsParameters;

@interface BMPhysicsHelper : BMModel

+ (BMDebugModel *)debugModelWithSprite:(CCSprite *)sprite;
+ (BMViewModel *)modelWithSprite:(CCSprite *)sprite;
+ (BMPhysicsParameters *)blockParamsWithLocation:(CGPoint)sLocation
                                        userData:(BMViewModel *)userData;
+ (BMPhysicsParameters *)ballParamsWithLocation:(CGPoint)sLocation
                                       userData:(BMViewModel *)userData;
+ (BMPhysicsParameters *)ballParamsWithLocation:(CGPoint)sLocation
                                  touchLocation:(CGPoint)tLocation
                                        impulse:(CGFloat)impulse
                                       userData:(BMViewModel *)userData;
+ (BMPhysicsParameters *)explosionParamsWithLocation:(CGPoint)sLocation
                                            userData:(BMViewModel *)userData;

@end

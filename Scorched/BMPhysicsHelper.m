//
//  BMPhysicsHelper.m
//  Scorched
//
//  Created by Mark Kim on 3/17/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMPhysicsHelper.h"
#import "BMViewModel.h"
#import "BMDebugModel.h"
#import "BMPhysicsParameters.h"

@implementation BMPhysicsHelper

+ (BMDebugModel *)debugModelWithSprite:(CCSprite *)sprite
{
    BMDebugModel *debugModel = [BMDebugModel node];
    
    debugModel.view.contentSize = sprite.contentSize;
    sprite.position = ccp(0.5 * debugModel.view.contentSize.width, 0.5 * debugModel.view.contentSize.height);
    
    [debugModel.view addChild:sprite];
    
    return debugModel;
}

+ (BMViewModel *)modelWithSprite:(CCSprite *)sprite
{
    BMViewModel *viewModel = [BMViewModel node];
    
    viewModel.view.contentSize = sprite.contentSize;
    sprite.position = ccp(0.5 * viewModel.view.contentSize.width, 0.5 * viewModel.view.contentSize.height);
    
    [viewModel.view addChild:sprite];
    
    return viewModel;
}

+ (BMPhysicsParameters *)blockParamsWithLocation:(CGPoint)sLocation
                                        userData:(BMViewModel *)userData
{
    userData.view.position = sLocation;
    
    NSNumber *shapeParam1 = [NSNumber numberWithFloat:userData.view.contentSize.width];
    NSNumber *shapeParam2 = [NSNumber numberWithFloat:userData.view.contentSize.height];
        
    BMPhysicsParameters *params = [BMPhysicsParameters parametersWithUserData:userData
                                                                     bodyType:kPhysicsBodyTypeDynamic
                                                                    shapeType:kSquareShape
                                                                  shapeParams:@[shapeParam1, shapeParam2]
                                                                      density:1.0
                                                                     friction:0.8
                                                                  restitution:0.3
                                                                     isSensor:false
                                                                startLocation:sLocation
                                                                touchLocation:CGPointZero
                                                                 impulseValue:0.0];
    return params;
}

+ (BMPhysicsParameters *)ballParamsWithLocation:(CGPoint)sLocation
                                       userData:(BMViewModel *)userData
{
    userData.view.position = sLocation;
    
    CGFloat radius = 0.5 * userData.view.contentSize.width;
    NSNumber *shapeParam1 = [NSNumber numberWithFloat:radius];
    
    BMPhysicsParameters *params = [BMPhysicsParameters parametersWithUserData:userData
                                                                     bodyType:kPhysicsBodyTypeDynamic
                                                                    shapeType:kCircleShape
                                                                  shapeParams:@[shapeParam1]
                                                                      density:1.0
                                                                     friction:0.8
                                                                  restitution:0.3
                                                                     isSensor:false
                                                                startLocation:sLocation
                                                                touchLocation:CGPointZero
                                                                 impulseValue:0.0];
    return params;
}

+ (BMPhysicsParameters *)ballParamsWithLocation:(CGPoint)sLocation
                                  touchLocation:(CGPoint)tLocation
                                        impulse:(CGFloat)impulse
                                       userData:(BMViewModel *)userData
{
    userData.view.position = sLocation;
    
    CGFloat radius = 0.5 * userData.view.contentSize.width;
    NSNumber *shapeParam1 = [NSNumber numberWithFloat:radius];
    
    BMPhysicsParameters *params = [BMPhysicsParameters parametersWithUserData:userData
                                                                     bodyType:kPhysicsBodyTypeDynamic
                                                                    shapeType:kCircleShape
                                                                  shapeParams:@[shapeParam1]
                                                                      density:1.0
                                                                     friction:0.8
                                                                  restitution:0.8
                                                                     isSensor:false
                                                                startLocation:sLocation
                                                                touchLocation:tLocation
                                                                 impulseValue:impulse];
    return params;
}

+ (BMPhysicsParameters *)explosionParamsWithLocation:(CGPoint)sLocation
                                            userData:(BMViewModel *)userData
{
    userData.view.position = sLocation;
    
    CGFloat radius = 0.5 * userData.view.contentSize.width;
    NSNumber *shapeParam1 = [NSNumber numberWithFloat:radius];
    
    BMPhysicsParameters *params = [BMPhysicsParameters parametersWithUserData:userData
                                                                     bodyType:kPhysicsBodyTypeDynamic
                                                                    shapeType:kCircleShape
                                                                  shapeParams:@[shapeParam1]
                                                                      density:1.0
                                                                     friction:0.8
                                                                  restitution:0.8
                                                                     isSensor:true
                                                                startLocation:sLocation
                                                                touchLocation:CGPointZero
                                                                 impulseValue:0.0];
    return params;
}

@end
















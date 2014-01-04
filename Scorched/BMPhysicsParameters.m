//
//  BMPhysicsParameters.m
//  Scorched
//
//  Created by Mark Kim on 12/4/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMPhysicsParameters.h"

@implementation BMPhysicsParameters

@synthesize userData = _userData;

- (void)dealloc
{
    [_userData release]; _userData = nil;
    [_shapeParams release]; _shapeParams = nil;
    
    [super dealloc];
}

- (id)initWithUserData:(BMViewModel *)userData
              bodyType:(BMPhysicsBodyType)bodyType
             shapeType:(BMShapeType)shapeType
           shapeParams:(NSArray *)shapeParams
               density:(CGFloat)density
              friction:(CGFloat)friction
           restitution:(CGFloat)restitution
              isSensor:(bool)isSensor
         startLocation:(CGPoint)startLocation
         touchLocation:(CGPoint)touchLocation
          impulseValue:(CGFloat)impulseValue
{
    if (self = [super init]) {
        _userData = [userData retain];
        _bodyType = bodyType;
        _shapeType = shapeType;
        _shapeParams = [shapeParams retain];
        _density = density;
        _friction = friction;
        _restitution = restitution;
        _isSensor = isSensor;
        _startLocation = startLocation;
        _touchLocation = touchLocation;
        _impulseValue = impulseValue;
    }
    return self;
}

+ (id)parametersWithUserData:(BMViewModel *)userData
                    bodyType:(BMPhysicsBodyType)bodyType
                   shapeType:(BMShapeType)shapeType
                 shapeParams:(NSArray *)shapeParams
                     density:(CGFloat)density
                    friction:(CGFloat)friction
                 restitution:(CGFloat)restitution
                    isSensor:(bool)isSensor
               startLocation:(CGPoint)startLocation
               touchLocation:(CGPoint)touchLocation
                impulseValue:(CGFloat)impulseValue
{
    return [[[self alloc] initWithUserData:userData
                                  bodyType:bodyType
                                 shapeType:shapeType
                               shapeParams:shapeParams
                                   density:density
                                  friction:friction
                               restitution:restitution
                                  isSensor:isSensor
                             startLocation:startLocation
                             touchLocation:touchLocation
                              impulseValue:impulseValue] autorelease];
}

@end

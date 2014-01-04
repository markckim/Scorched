//
//  BMPhysicsParameters.h
//  Scorched
//
//  Created by Mark Kim on 12/4/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@class BMViewModel;

// TODO: refactor this with defined Shapes with density, friction, restitution, etc., already defined from client perspective
// so we don't have to pass back and forth too much data
@interface BMPhysicsParameters : BMModel

@property (nonatomic, retain) BMViewModel *userData; // TODO: - Mark Kim - rename; it's blocking CCNode's userData property
@property (nonatomic, assign) BMPhysicsBodyType bodyType;
@property (nonatomic, assign) BMShapeType shapeType;
@property (nonatomic, retain) NSArray *shapeParams;
@property (nonatomic, assign) CGFloat density;
@property (nonatomic, assign) CGFloat friction;
@property (nonatomic, assign) CGFloat restitution;
@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) bool isSensor;

// TODO: - Mark Kim - modify; touchLocation is for temporary use; should use an angle later
@property (nonatomic, assign) CGPoint touchLocation;

@property (nonatomic, assign) CGFloat impulseValue;

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
          impulseValue:(CGFloat)impulseValue;

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
                impulseValue:(CGFloat)impulseValue;

@end

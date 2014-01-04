//
//  enum_constants.h
//  Scorched
//
//  Created by Mark Kim on 4/11/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#ifndef Scorched_enum_constants_h
#define Scorched_enum_constants_h

typedef enum {
    kSceneTypeNone,
    kSplashScene,
    kGatewayScene,
    kMenuScene,
    kGameScene,
    kTestScene,
} BMSceneType;

typedef enum {
    kModelTypeNone,
    kProjectileModel,
    kHeroModel,
    kPlayerModel,
    kEdgeModel,
    kDebugModel,
    kGroundModel,
} BMModelType;

typedef enum {
    kShapeTypeNone,
    kCircleShape,
    kSquareShape,
} BMShapeType;

typedef enum {
    kAvatarTypeNone,
    kAvatarDefault,
} BMAvatarType;

typedef enum {
    kPhysicsBodyTypeStatic,
    kPhysicsBodyTypeKinematic,
    kPhysicsBodyTypeDynamic,
} BMPhysicsBodyType;

typedef enum {
    kWest,
    kNorthWest,
    kNorth,
    kNorthEast,
    kEast,
    kSouthEast,
    kSouth,
    kSouthWest,
} BMDirectionType;

#endif

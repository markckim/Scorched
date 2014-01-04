//
//  BMGameController.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMController.h"

@class BMDebugView;
@class BMSurfaceView;
@class BMGamePlayView;
@class BMTouchView;
@class BMPhysics;
@class BMPlayer;
@class BMCamera;

@protocol BMPhysicsDelegate;

@interface BMGameController : BMController <BMTouchViewDelegate, BMPhysicsDelegate>

@property (nonatomic, retain) BMDebugView           *debugView;
@property (nonatomic, retain) BMTouchView           *touchView;
@property (nonatomic, retain) BMGamePlayView        *gamePlayView;
@property (nonatomic, retain) BMSurfaceView         *surfaceView;
@property (nonatomic, retain) BMPhysics             *physics;
@property (nonatomic, retain) CCMenu                *topMenu;
@property (nonatomic, retain) NSMutableArray        *gameObjects;
@property (nonatomic, retain) BMCamera              *worldCamera;

@end

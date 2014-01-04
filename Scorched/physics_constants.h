//
//  physics_constants.h
//  Scorched
//
//  Created by Mark Kim on 11/29/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#define FIXED_TIME_STEP 1.0f / 60.0f
#define VELOCITY_ITERATIONS 10
#define POSITION_ITERATIONS 10
#define PTM_RATIO 32.0f
#define GRAVITY_VECTOR b2Vec2(0.0, -10.0)

#define FIXTURE_STRIDE (1 * CC_CONTENT_SCALE_FACTOR()) // goal: 4
#define NEIGHBOR_STEP 1
#define PIXEL_STEP_X (5 * CC_CONTENT_SCALE_FACTOR()) // step x value for the grid // goal: 8
#define PIXEL_STEP_Y (5 * CC_CONTENT_SCALE_FACTOR()) // step y value for the grid // goal: 8
#define IMAGE_PIXEL_STEP_X (32 * CC_CONTENT_SCALE_FACTOR()) // step x value for the image // goal: 80
#define IMAGE_PIXEL_STEP_Y (24 * CC_CONTENT_SCALE_FACTOR()) // step y value for the image // goal: 80
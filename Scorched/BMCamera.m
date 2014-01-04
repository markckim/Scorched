//
//  BMCamera.m
//  Scorched
//
//  Created by Mark Kim on 5/4/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#define FRICTION_FACTOR -1000.0

#import "BMCamera.h"
#import "BMWorldView.h"
#import "physics_functions.h"

@interface BMCamera ()
{
    CGPoint _magnitudeVelocity;
    CGPoint _unitVelocity;
}

@property (nonatomic, retain) NSMutableArray *worldViews;

- (CGPoint)_boundWorldView:(BMWorldView *)worldView pos:(CGPoint)pos;
- (CGFloat)_boundScale:(CGFloat)scale;
- (void)_panWithTranslation:(CGPoint)translation;
- (void)_scaleWithAmount:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation;

@end

@implementation BMCamera

- (void)dealloc
{
    [_worldViews release]; _worldViews = nil;
    [super dealloc];
}

- (CGPoint)_boundWorldView:(BMWorldView *)worldView pos:(CGPoint)pos
{
    // TODO: - Mark Kim - something seems slightly wrong; fix
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat clampedX = clampf(pos.x, -0.5 * TEST_IMAGE_SIZE.width * worldView.scale + winSize.width, 0.5 * TEST_IMAGE_SIZE.width * worldView.scale);
    CGFloat clampedY = clampf(pos.y, -0.5 * TEST_IMAGE_SIZE.height * worldView.scale + winSize.height, 0.5 * TEST_IMAGE_SIZE.height * worldView.scale);
    //debug(@"newPos: %@, clampedPos: %@", stringForPoint(newPos), stringForPoint(ccp(clampedX, clampedY)));
    return ccp(clampedX, clampedY);
}

- (CGFloat)_boundScale:(CGFloat)scale
{
    // finds side that will clamp first and make that the lower scale
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat minScale = MAX(winSize.width / TEST_IMAGE_SIZE.width, winSize.height / TEST_IMAGE_SIZE.height);
    CGFloat clampedScale = clampf(scale, minScale, 2.0);
    return clampedScale;
}

- (void)_panWithTranslation:(CGPoint)translation
{
    for (BMWorldView *worldView in _worldViews) {
        CGPoint newPos = ccpAdd(worldView.view.position, translation);
        worldView.view.position = [self _boundWorldView:worldView pos:newPos];
    }
}

- (void)_scaleWithAmount:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation
{
    for (BMWorldView *worldView in _worldViews) {
        CGFloat newScaleAmount = worldView.scale + scaleAmount;
        worldView.scale = [self _boundScale:newScaleAmount];
        worldView.view.position = [self _boundWorldView:worldView pos:worldView.view.position];
    }
}

- (void)update:(ccTime)delta
{
    if (_magnitudeVelocity.x > 0.0 || _magnitudeVelocity.y > 0.0) {
        
        CGFloat dX = _magnitudeVelocity.x * _unitVelocity.x * delta;
        CGFloat dY = _magnitudeVelocity.y * _unitVelocity.y * delta;
        _magnitudeVelocity.x = MAX(0.0, _magnitudeVelocity.x + FRICTION_FACTOR * delta);
        _magnitudeVelocity.y = MAX(0.0, _magnitudeVelocity.y + FRICTION_FACTOR * delta);
        
        CGPoint translation = ccp(dX, dY);
        [self _panWithTranslation:translation];
    }
}

- (void)setVelocity:(CGPoint)velocity
{
    _unitVelocity = unitVector(velocity);
    
    // capping magnitude velocity to 1000.0 in x and y directions
    _magnitudeVelocity = ccp(MIN(1000.0, ABS(velocity.x)), MIN(1000.0, ABS(velocity.y)));
}

- (void)_resetVelocity
{
    _magnitudeVelocity = CGPointZero;
    _unitVelocity = CGPointZero;
}

- (void)panWithTranslation:(CGPoint)translation
{
    //debug(@"translation: %f, %f", translation.x, translation.y);
    [self _resetVelocity];
    [self _panWithTranslation:translation];
}

- (void)scaleWithAmount:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation
{
    [self _resetVelocity];
    [self _scaleWithAmount:scaleAmount touchLocation:touchLocation];
}

- (id)initWithWorldViews:(NSArray *)worldViews
{
    if (self = [super init]) {
        // TODO: - Mark Kim - add data validation
        _magnitudeVelocity = CGPointZero;
        _unitVelocity = CGPointZero;
        _worldViews = [[NSMutableArray alloc] initWithArray:worldViews];
    }
    return self;
}

@end

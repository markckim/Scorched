//
//  BMTestController.m
//  Scorched
//
//  Created by Mark Kim on 4/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMTestController.h"
#import "BMTestView.h"
#import "basic_functions.h"
#import "BMTestTouchView.h"

@implementation BMTestController

- (void)dealloc
{
    [_backMenuButton release]; _backMenuButton = nil;
    [_testView release]; _testView = nil;
    [_testTouchView release]; _testTouchView = nil;
    
    [super dealloc];
}

// TODO: - Mark Kim - make better architecturally ?
- (CGPoint)_boundPos:(CGPoint)newPos
{    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat clampedX = clampf(newPos.x, -0.5 * TEST_IMAGE_SIZE.width * _testView.scale + winSize.width, 0.5 * TEST_IMAGE_SIZE.width * _testView.scale);
    CGFloat clampedY = clampf(newPos.y, -0.5 * TEST_IMAGE_SIZE.height * _testView.scale + winSize.height, 0.5 * TEST_IMAGE_SIZE.height * _testView.scale);
    //debug(@"newPos: %@, clampedPos: %@", stringForPoint(newPos), stringForPoint(ccp(clampedX, clampedY)));
    return ccp(clampedX, clampedY);
}

- (void)_panWithTranslation:(CGPoint)translation
{
    debug(@"translation: %f, %f", translation.x, translation.y);
    CGPoint newPos = ccpAdd(_testView.testSprite.position, translation);
    _testView.testSprite.position = [self _boundPos:newPos];
}

- (CGFloat)_boundScale:(CGFloat)newScale
{
    // find side that will clamp first and make that the lower scale
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat minScale = MAX(winSize.width / TEST_IMAGE_SIZE.width, winSize.height / TEST_IMAGE_SIZE.height);
    CGFloat clampedScale = clampf(newScale, minScale, 2.0);
    return clampedScale;
}

- (void)_scaleWithAmount:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation
{
    _testView.scale = [self _boundScale:_testView.scale + scaleAmount];
    _testView.testSprite.position = [self _boundPos:_testView.testSprite.position];
}

// BMTestTouchViewDelegate methods

- (void)didTapLocation:(CGPoint)touchLocation
{
    CGPoint convertedTouchLocation = [_testView.testSprite convertToNodeSpace:touchLocation];
    debug(@"touchPoint: %f, %f, nodePoint: %f, %f", touchLocation.x, touchLocation.y, convertedTouchLocation.x, convertedTouchLocation.y);
}

- (void)didTranslateBy:(CGPoint)translation
{
    [self _panWithTranslation:translation];
}

- (void)didScaleBy:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation
{
    [self _scaleWithAmount:scaleAmount touchLocation:touchLocation];
}

- (id)init
{
    if (self = [super init]) {
        _testView = [[BMTestView alloc] init];
        _testTouchView = [[BMTestTouchView alloc] initWithDelegate:self];
        
        _backMenuButton = [[self addBackButtonToGateway] retain];
        [self addChild:_testView z:1];
        [self addChild:_testTouchView z:2];
    }
    return self;
}

@end

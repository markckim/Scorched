//
//  BMTouchView.m
//  Scorched
//
//  Created by Mark Kim on 4/17/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMTouchView.h"

@interface BMTouchView ()
{
    id<BMTouchViewDelegate> _delegate;
    CGPoint _previousPanPoint;
    
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    UITapGestureRecognizer *_tapGestureRecognizer;
}
@end

@implementation BMTouchView

- (void)dealloc
{
    _delegate = nil;
    [_pinchGestureRecognizer release]; _pinchGestureRecognizer = nil;
    [_panGestureRecognizer release]; _panGestureRecognizer = nil;
    [_pinchGestureRecognizer release]; _pinchGestureRecognizer = nil;
    
    [super dealloc];
}

- (void)onEnter
{
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_tapGestureRecognizer];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_panGestureRecognizer];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_pinchGestureRecognizer];
    [super onEnter];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_tapGestureRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_panGestureRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_pinchGestureRecognizer];
    [super onExit];
}

/*
 * UITapGestureRecognizer calls _handleTap when its state is
 * UIGestureRecognizerStateEnded
 */
- (void)_handleTap:(UITapGestureRecognizer *)recognizer
{
    //debug(@"_handleTap called");
    CCDirector  *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [recognizer locationInView:director.view];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    
    switch ( recognizer.state ) {
        case UIGestureRecognizerStateEnded:
            [_delegate didTapLocation:glTouchLocation];
            break;
        default:
            break;
    }
}

/*
 * UIPanGestureRecognizer calls _handlePan when its state is
 * UIGestureRecognizerStateBegan
 * UIGestureRecognizerStateChanged
 * UIGestureRecognzizerStateEnded
 */
- (void)_handlePan:(UIPanGestureRecognizer *)recognizer
{
    //debug(@"_handlPan called");
    CCDirector  *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [recognizer locationInView:director.view];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    
    CGPoint translation;
    CGPoint velocity;
    
    switch ( recognizer.state ) {
        case UIGestureRecognizerStateBegan:
            //debug(@"UIGestureRecognizerStateBegan");
            _previousPanPoint = glTouchLocation;
            break;
        case UIGestureRecognizerStateChanged:
            //debug(@"UIGestureRecognizerStateChanged");
            translation = ccpSub(glTouchLocation, _previousPanPoint);
            [_delegate didTranslateBy:translation];
            _previousPanPoint = glTouchLocation;
            break;
        case UIGestureRecognizerStateEnded:
            //debug(@"UIGestureRecognizerStateEnded");
            velocity = [recognizer velocityInView:[CCDirector sharedDirector].view];
            CGPoint convertedVelocity = ccp(velocity.x, -velocity.y);
            [_delegate didEndPanWithVelocity:convertedVelocity];
            break;
        default:
            break;
    }
}

/*
 * UIPinchGestureRecognizer calls _handlePinch when its state is
 * UIGestureRecognizerStateBegan
 * UIGestureRecognizerStateChanged
 * UIGestureRecognzizerStateEnded
 */
- (void)_handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    //debug(@"_handlePinch called");
    CCDirector  *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [recognizer locationInView:director.view];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    CGFloat scaleAmount;
    
    switch ( recognizer.state ) {
        case UIGestureRecognizerStateBegan:
            //debug(@"UIGestureRecognizerStateBegan");
            break;
        case UIGestureRecognizerStateChanged:
            //debug(@"UIGestureRecognizerStateChanged");
            scaleAmount = recognizer.scale - 1.0;
            //debug(@"scaleAmount: %f", scaleAmount);
            [_delegate didScaleBy:scaleAmount touchLocation:glTouchLocation];
            recognizer.scale = 1.0;
            break;
        case UIGestureRecognizerStateEnded:
            //debug(@"UIGestureRecognizerStateEnded");
            break;
        default:
            break;
    }
}

- (id)initWithDelegate:(id<BMTouchViewDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _previousPanPoint = CGPointZero;
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePinch:)];
    }
    return self;
}

@end

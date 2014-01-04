//
//  BMTestTouchView.m
//  Scorched
//
//  Created by Mark Kim on 4/18/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMTestTouchView.h"

@interface BMTestTouchView ()
{
    id<BMTestTouchViewDelegate> _delegate;
    CGPoint _previousPanPoint;
    CGFloat _lastScale;
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    UITapGestureRecognizer *_tapGestureRecognizer;
}
@end

@implementation BMTestTouchView

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
    NSAssert(_tapGestureRecognizer && _panGestureRecognizer && _pinchGestureRecognizer, @"gesture recognizers not all set!");
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_tapGestureRecognizer];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_panGestureRecognizer];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_pinchGestureRecognizer];
    [super onEnter];
}

- (void)onExit
{
    NSAssert(_tapGestureRecognizer && _panGestureRecognizer && _pinchGestureRecognizer, @"gesture recognizers not all set!");
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_tapGestureRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_panGestureRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_pinchGestureRecognizer];
    [super onExit];
}

//- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
//{
//    NSAssert(_testView, @"_testView is not set!");
//    debug(@"handlePinch: called");
//    switch( recognizer.state ) {
//        case UIGestureRecognizerStatePossible:
//        case UIGestureRecognizerStateBegan:
//            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
//            //(do something when the pan begins)
//            recognizer.scale = _testView.scale;
//            break;
//        case UIGestureRecognizerStateChanged:
//            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
//            //(do something while the pan is in progress)
//            _testView.scale = recognizer.scale;
//            break;
//        case UIGestureRecognizerStateFailed:
//            break;
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
//            //(do something when the pan ends)
//            //(the below gets the velocity; good for letting player "fling" things)
//            //v = [recognizer velocityInView:[CCDirector sharedDirector].openGLView];
//            break;
//    }
//}

/*
 * UITapGestureRecognizer calls _handleTap when its state is
 * UIGestureRecognizerStateEnded
 */
- (void)_handleTap:(UITapGestureRecognizer *)recognizer
{
    debug(@"_handleTap called");
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
    debug(@"_handlPan called");
    CCDirector  *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [recognizer locationInView:director.view];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    CGPoint translation;
    
    switch ( recognizer.state ) {
        case UIGestureRecognizerStateBegan:
            debug(@"UIGestureRecognizerStateBegan");
            _previousPanPoint = glTouchLocation;
            break;
        case UIGestureRecognizerStateChanged:
            debug(@"UIGestureRecognizerStateChanged");
            translation = ccpSub(glTouchLocation, _previousPanPoint);
            [_delegate didTranslateBy:translation];
            _previousPanPoint = glTouchLocation;
            break;
        case UIGestureRecognizerStateEnded:
            debug(@"UIGestureRecognizerStateEnded");
            // TODO: - Mark Kim - do something with velocity here
            translation = ccpSub(glTouchLocation, _previousPanPoint);
            [_delegate didTranslateBy:translation];
            _previousPanPoint = glTouchLocation;
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
    debug(@"_handlePinch called");
    CCDirector  *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [recognizer locationInView:director.view];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    
    // TODO: - Mark Kim - need to bound scale here (e.g., < 1.0, > ??)
    CGFloat scaleAmount;
    
    switch ( recognizer.state ) {
        case UIGestureRecognizerStateBegan:
            debug(@"UIGestureRecognizerStateBegan");
            _lastScale = 1.0;
            break;
        case UIGestureRecognizerStateChanged:
            debug(@"UIGestureRecognizerStateChanged");
            scaleAmount = recognizer.scale - _lastScale;
            debug(@"scaleAmount: %f", scaleAmount);
            [_delegate didScaleBy:scaleAmount touchLocation:glTouchLocation];
            recognizer.scale = _lastScale;
            break;
        case UIGestureRecognizerStateEnded:
            debug(@"UIGestureRecognizerStateEnded");
            //scaleAmount = 1.0 - (_lastScale + recognizer.scale);
            //[_delegate didScaleBy:scaleAmount touchLocation:glTouchLocation];
            //_lastScale = recognizer.scale;
            break;
        default:
            break;
    }
}

- (id)initWithDelegate:(id<BMTestTouchViewDelegate>)delegate
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

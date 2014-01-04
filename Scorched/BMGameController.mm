//
//  BMGameController.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMGameController.h"

#import "BMDamage.h"
#import "BMDebugModel.h"
#import "BMDebugView.h"
#import "BMTouchView.h"
#import "BMGamePlayView.h"
#import "BMPhysics.h"
#import "BMPhysicsHelper.h"
#import "BMPhysicsParameters.h"
#import "BMSurfaceView.h"
#import "BMCamera.h"

#import "Box2D.h"
#import "util_functions.h"

@interface BMGameController ()

- (void)_initGamePlayView;
- (void)_initDebugView;
- (void)_initButtons;

// BMGamePlayViewDelegate methods
- (void)didTapLocation:(CGPoint)touchLocation;
- (void)didTranslate:(CGPoint)translation;

// BMPhysicsDelegate methods
- (void)willDestroyBodyFixtureWithUserData:(id)userData;
- (void)didDestroyBodyFixtureWithUserData:(id)userData;
- (void)didUpdatePositionForBody:(b2Body *)body;
- (void)bodyDidContactGround:(b2Body *)body;
- (void)body:(b2Body *)body1 didContactOtherBody:(b2Body *)body2;

@end

@implementation BMGameController

- (void)dealloc
{
    [_worldCamera release]; _worldCamera = nil;
    [_touchView release]; _touchView = nil;
    [_gamePlayView release]; _gamePlayView = nil;
    [_surfaceView release]; _surfaceView = nil;
    [_topMenu release]; _topMenu = nil;
    [_physics release]; _physics = nil;
    [_gameObjects release]; _gameObjects = nil;
    [_debugView release]; _debugView = nil;
        
    [super dealloc];
}

- (void)_initButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
        
    CCLabelBMFont *menuLabel1 = [CCLabelBMFont labelWithString:@"create p1"
                                                       fntFile:@"MushroomTextMedium.fnt"
                                                         width:100.0
                                                     alignment:kCCTextAlignmentCenter];
    
    CCLabelBMFont *menuLabel2 = [CCLabelBMFont labelWithString:@"create ai"
                                                       fntFile:@"MushroomTextMedium.fnt"
                                                         width:100.0
                                                     alignment:kCCTextAlignmentCenter];
    
    CCMenuItemLabel *menuItem1 = [CCMenuItemLabel itemWithLabel:menuLabel1
                                                         target:self
                                                       selector:@selector(didTapCreatePlayerButton:)];
    
    CCMenuItemLabel *menuItem2 = [CCMenuItemLabel itemWithLabel:menuLabel2
                                                         target:self
                                                       selector:@selector(didTapCreateAiButton:)];
    
    self.topMenu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
    [_topMenu alignItemsHorizontallyWithPadding:50.0];
    
    _topMenu.position = ccp(winSize.width/2, winSize.height - menuItem1.contentSize.height/2);
}

- (void)update:(ccTime)delta
{
    [_physics update:delta];
    [_worldCamera update:delta];
}

- (void)_createExplosiveWithStartLocation:(CGPoint)sLocation
{
    BMDebugModel *debugModel = [BMPhysicsHelper debugModelWithSprite:[CCSprite spriteWithFile:@"ball.png"]];
    BMPhysicsParameters *params = [BMPhysicsHelper explosionParamsWithLocation:sLocation
                                                                      userData:debugModel];
    [_gameObjects addObject:debugModel];
    [_gamePlayView.view addChild:debugModel.view];
    
    [_physics queueBodyWithParameters:params];
}

- (void)_createBallWithStartLocation:(CGPoint)sLocation
{
    BMViewModel *viewModel = [BMPhysicsHelper modelWithSprite:[CCSprite spriteWithFile:@"ball2.png"]];
    BMPhysicsParameters *params = [BMPhysicsHelper ballParamsWithLocation:sLocation
                                                                  userData:viewModel];
    [_gameObjects addObject:viewModel];
    [_gamePlayView.view addChild:viewModel.view];
    
    [_physics queueBodyWithParameters:params];
}

- (void)_createBlockWithStartLocation:(CGPoint)sLocation
{
    BMViewModel *viewModel = [BMPhysicsHelper modelWithSprite:[CCSprite spriteWithFile:@"square1.png"]];
    BMPhysicsParameters *params = [BMPhysicsHelper blockParamsWithLocation:sLocation
                                                                  userData:viewModel];
    [_gameObjects addObject:viewModel];
    [_gamePlayView.view addChild:viewModel.view];
    
    [_physics queueBodyWithParameters:params];
}

// BMTouchViewDelegate protocol methods

- (void)didTapLocation:(CGPoint)touchLocation
{
    CGPoint gamePlayViewTouchLocation = [_gamePlayView.view convertToNodeSpace:touchLocation];
    CGFloat radius = 20.0;
    [_debugView updateCircleEdgesMapWithCenter:gamePlayViewTouchLocation radius:radius];
    BMDamage *damage = [BMDamage damageWithCenterPoint:gamePlayViewTouchLocation radius:radius];
    [_physics queueDamage:damage];
}

- (void)didTranslateBy:(CGPoint)translation
{
    [_worldCamera panWithTranslation:translation];
}

- (void)didEndPanWithVelocity:(CGPoint)touchVelocity
{
    //debug(@"velocity: %f, %f", touchVelocity.x, touchVelocity.y);
    [_worldCamera setVelocity:ccp(touchVelocity.x, touchVelocity.y)];
}

- (void)didScaleBy:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation
{
    [_worldCamera scaleWithAmount:scaleAmount touchLocation:touchLocation];
}

// BMPhysicsDelegate protocol methods

- (void)willDestroyBodyFixtureWithUserData:(id)userData {}

- (void)didDestroyBodyFixtureWithUserData:(id)userData
{
    // note: there is at least 1 userData per fixture on the body
    // note: can be called more than once if body has more than 1 fixture
    BMViewModel *viewModel = (BMViewModel *)userData;
    [_gamePlayView.view removeChild:viewModel.view cleanup:YES];
    [_gameObjects removeObject:viewModel];
}

- (void)didUpdatePositionForBody:(b2Body *)body
{
    // note: since each fixture on the body can have a viewModel attached to it
    // note: need to go through each fixture on the body and update its position
    for (b2Fixture *fixture = body->GetFixtureList(); fixture; fixture = fixture->GetNext()) {
        BMViewModel *viewModel = (BMViewModel *)fixture->GetUserData();
        if (viewModel) {
            CGPoint newPositionPoint = ccp(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
            viewModel.view.position = newPositionPoint;
            viewModel.view.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
        }
    }
}

- (void)bodyDidContactGround:(b2Body *)body
{
    BMViewModel *viewModel = (BMViewModel *)body->GetUserData();
    if (viewModel.modelType == kPlayerModel) {
        return;
    }
}

// TODO: - Mark Kim - rework physics protocol.. do i need this method or do i need a different method dealing with fixtures?
- (void)body:(b2Body *)body1 didContactOtherBody:(b2Body *)body2 {}

// init

- (id)init
{
    if (self = [super init]) {
        
        self.sceneTypeId = kGameScene;
        
        // note: this is an array of BMSpriteInfo objects
        NSArray *positionedSpritesInfo = positionedSpritesFromImage([UIImage imageNamed:TEST_IMAGE_NAME], IMAGE_PIXEL_STEP_X, IMAGE_PIXEL_STEP_Y);
        
        _gameObjects = [[NSMutableArray alloc] init];
        _touchView = [[BMTouchView alloc] initWithDelegate:self];
        _gamePlayView = [[BMGamePlayView alloc] init];
        _surfaceView = [[BMSurfaceView alloc] initWithSprites:positionedSpritesInfo];
        _physics = [[BMPhysics alloc] initWithDelegate:self spritesInfo:positionedSpritesInfo];
        _debugView = [[BMDebugView alloc] initWithGroundUnits:_physics.groundUnits];
        _worldCamera = [[BMCamera alloc] initWithWorldViews:@[_gamePlayView, _surfaceView, _debugView]];
        
        [self addBackButtonToGateway];
        [self addChild:_surfaceView z:1];
        [self addChild:_gamePlayView z:2];
        [self addChild:_touchView z:3];
        [self addChild:_debugView z:99];
        
        // creating test blocks
        CGSize viewSize = TEST_IMAGE_SIZE;
        [self _createBlockWithStartLocation:ccp(0.19 * viewSize.width, 0.9 * viewSize.height)];
        //[self _createBallWithStartLocation:ccp(viewSize.width/2 - 25, viewSize.height*2/3)];
        //[self _createBallWithStartLocation:ccp(viewSize.width/2 + 25, viewSize.height*2/3)];
        
        [self scheduleUpdate];
    }
    return self;
}

@end












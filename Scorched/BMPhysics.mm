//
//  BMPhysics.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMPhysics.h"

#import "BMDamage.h"
#import "BMEdge.h"
#import "BMGround.h"
#import "BMPhysicsParameters.h"
#import "BMSpriteInfo.h"

#import "util_functions.h"

// note: this protocol is placed here b/c it contains C++ code (e.g., b2Body)
// which doesn't work well with h files (e.g., game_protocols.h)
// this protocol is placed here for reference only
@protocol BMPhysicsDelegate
- (void)willDestroyBodyFixtureWithUserData:(id)userData;
- (void)didDestroyBodyFixtureWithUserData:(id)userData;
- (void)didUpdatePositionForBody:(b2Body *)body;
- (void)bodyDidContactGround:(b2Body *)body;
- (void)body:(b2Body *)body1 didContactOtherBody:(b2Body *)body2;
@end

@interface BMPhysics ()
{
    b2World                             *_world;
    BMContactListener                   *_contactListener;
    std::vector<b2Body*>                _bodiesToDestroy;
    std::map<NSString*, b2Body*>        _groundBodyMap;
    
    NSMutableArray                      *_queuedDamage;
    NSMutableArray                      *_queuedParameters;
    CGFloat                             _timeAccumulator;
    
    id<BMPhysicsDelegate>               _delegate;
}

// initializing physics world
- (void)_initWorld;
- (void)_initListener;
- (void)_reloadGroundBodyWithGround:(BMGround *)ground;

// body life cycle methods
- (void)_processBody:(b2Body *)body;
- (void)_destroyBody:(b2Body *)body;
- (void)_createBodyWithParameters:(BMPhysicsParameters *)params;
- (void)_removeGroundWithDamage:(BMDamage *)damage;

// collision management
- (void)_updateGround:(BMGround *)ground withEdgePoints:(NSArray *)edgePoints;
- (void)_processContact:(BMContact)contact;

@end

@implementation BMPhysics

- (void)dealloc
{
    delete _world; _world = nil;
    delete _contactListener; _contactListener = nil;
    
    [_queuedDamage release]; _queuedDamage = nil;
    [_queuedParameters release]; _queuedParameters = nil;
    [_groundUnits release]; _groundUnits = nil;
    _delegate = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)delta
{
    _timeAccumulator += delta;
    
    while (_timeAccumulator >= FIXED_TIME_STEP)
    {
        _timeAccumulator -= FIXED_TIME_STEP;
        _world->Step(FIXED_TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
        
        // update positions
        for (b2Body *body = _world->GetBodyList(); body; body = body->GetNext()) {
            // TODO: - Mark Kim - make sure to always set userData for bodies
            BMModel *userData = (BMModel *)body->GetUserData();
            if (userData.modelType != kGroundModel) {
                [self _processBody:body];
            }
        }
        
        // update collisions
        std::vector<BMContact>::iterator cPos;
        for (cPos = _contactListener->_contacts.begin(); cPos != _contactListener->_contacts.end(); ++cPos) {
            [self _processContact:*cPos];
        }
        
        // destroy queued bodies to destroy
        std::vector<b2Body*>::iterator bPos;
        for (bPos = _bodiesToDestroy.begin(); bPos != _bodiesToDestroy.end(); ++bPos) {
            [self _destroyBody:*bPos];
        }
        _bodiesToDestroy.clear();
        
        // create queued bodies to create
        for (BMPhysicsParameters *params in _queuedParameters) {
            [self _createBodyWithParameters:params];
        }
        [_queuedParameters removeAllObjects];
        
        for (BMDamage *damage in _queuedDamage) {
            [self _removeGroundWithDamage:damage];
        }
        [_queuedDamage removeAllObjects];
    }
}

- (void)queueBodyWithParameters:(BMPhysicsParameters *)params
{
    //NSAssert([params isKindOfClass:[BMPhysicsParameters class]], @"ERROR: params is not kind of class BMPhysicsParameters!");
    [_queuedParameters addObject:params];
}

- (void)queueDamage:(BMDamage *)damage
{
    //NSAssert([damage isKindOfClass:[BMDamage class]], @"ERROR: damage is not kind of class BMDamage!");
    [_queuedDamage addObject:damage];
}

- (void)_createBodyWithParameters:(BMPhysicsParameters *)params
{
    // create body on world
    b2BodyDef bodyDef;
    
    if (params.bodyType == kPhysicsBodyTypeStatic) {
        bodyDef.type = b2_staticBody;
    } else if (params.bodyType == kPhysicsBodyTypeKinematic) {
        bodyDef.type = b2_kinematicBody;
    } else {
        bodyDef.type = b2_dynamicBody;
    }
    
    bodyDef.position = b2Vec2(params.startLocation.x / PTM_RATIO, params.startLocation.y / PTM_RATIO);
    b2Body *body = _world->CreateBody(&bodyDef);
    
    // create fixture on body
    b2FixtureDef fixtureDef;
    fixtureDef.userData = params.userData;
    fixtureDef.density = params.density;
    fixtureDef.friction = params.friction;
    fixtureDef.restitution = params.restitution;
    fixtureDef.isSensor = params.isSensor;
    
    if (params.shapeType == kCircleShape) {
        b2CircleShape shape;
        shape.m_radius = [[params.shapeParams objectAtIndex:0] floatValue] / PTM_RATIO;
        fixtureDef.shape = &shape;
        body->CreateFixture(&fixtureDef);
    } else if (params.shapeType == kSquareShape) {
        b2PolygonShape shape;
        CGFloat width = [[params.shapeParams objectAtIndex:0] floatValue];
        CGFloat height = ([params.shapeParams count] > 1) ? [[params.shapeParams objectAtIndex:1] floatValue] : [[params.shapeParams objectAtIndex:0] floatValue];
        shape.SetAsBox(0.5 * width / PTM_RATIO, 0.5 * height / PTM_RATIO);
        fixtureDef.shape = &shape;
        body->CreateFixture(&fixtureDef);
    }
    
    // apply impulse if available
    if (params.impulseValue != 0) {
        CGPoint unitVector = unitVectorFromTo(params.startLocation, params.touchLocation);        
        b2Vec2 impulsePosition = body->GetPosition();
        body->ApplyLinearImpulse(b2Vec2(params.impulseValue * unitVector.x / PTM_RATIO,
                                        params.impulseValue * unitVector.y / PTM_RATIO),
                                 impulsePosition);
    }
}

- (void)_destroyBody:(b2Body *)body
{
    NSMutableArray *userDataArray = [[NSMutableArray alloc] init];
    for (b2Fixture *fixture = body->GetFixtureList(); fixture; fixture = fixture->GetNext()) {
        id userData = (id)fixture->GetUserData();
        if (userData) {
            [userDataArray addObject:userData];
            [_delegate willDestroyBodyFixtureWithUserData:userData];
        }
    }
    
    _world->DestroyBody(body);
    
    for (id userData in userDataArray) {
        [_delegate didDestroyBodyFixtureWithUserData:userData];
    }
    
    [userDataArray release];
}

- (void)_processContact:(BMContact)contact
{
    // do stuff
}

- (void)queueBodyToDestroy:(b2Body *)body
{
    // i think i need to add this if statement for the case of multiple fixtures attached to one body
    // e.g., if multiple fixtures contact both ground and ball, it may be accidentally added to
    // _bodiesToDestroy more than once; this is to prevent this from happening
    std::vector<b2Body*>::iterator posBody;
    posBody = std::find(_bodiesToDestroy.begin(), _bodiesToDestroy.end(), body);
    if (posBody == _bodiesToDestroy.end()) {
        _bodiesToDestroy.push_back(body);
    }
}

- (void)_processBody:(b2Body *)body
{
    [_delegate didUpdatePositionForBody:body];
}

- (void)_removeGroundWithDamage:(BMDamage *)damage
{
    if (_groundUnits && [_groundUnits count] > 0) {
        
        int intersect_debug_count = 0;
        CGFloat debug_duration_in_secs = 0.0;
        
        for (BMGround *ground in _groundUnits) {
            CGRect spritePixelRect = pixelRectForSprite(ground.view, 0);
            if (doesCircleIntersectRect(damage.centerPoint, damage.radius, spritePixelRect)) {
                ++intersect_debug_count;
                [ground removeGroundWithDamage:damage];
                debug_duration_in_secs += [ground reload];
            }
        }
        debug(@"### remove ground time (secs): %f tiles affected: %d", debug_duration_in_secs, intersect_debug_count);
    }
}

- (void)_initWorld
{
    if (!_world) {
        _world = new b2World(GRAVITY_VECTOR);
    }
}

- (void)_initListener
{
    if (_world && !_contactListener) {
        _contactListener = new BMContactListener();
        _world->SetContactListener(_contactListener);
    }
}

// BMGroundDelegate method
- (void)ground:(BMGround *)ground didReloadData:(NSArray *)edgePoints
{
    [self _updateGround:ground withEdgePoints:edgePoints];
}

- (void)_reloadGroundBodyWithGround:(BMGround *)ground
{
    b2Body *groundBody = _groundBodyMap[ground.key];
    if (_world && groundBody) {
        _world->DestroyBody(groundBody);
        groundBody = nil;
    }
    
    if (_world && !groundBody) {
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        groundBodyDef.userData = ground;
        groundBody = _world->CreateBody(&groundBodyDef);
        _groundBodyMap[ground.key] = groundBody;
    }
}

- (void)_updateGround:(BMGround *)ground withEdgePoints:(NSArray *)edgePoints
{    
    // destroys current _groundBody (removing all existing edge fixtures) and creates a new _groundBody
    NSAssert(ground.key, @"ground requires key!");
    [self _reloadGroundBodyWithGround:ground];
    
    // updates edges
    if (edgePoints && [edgePoints count] > 0) {
        b2EdgeShape groundEdgeShape;
        b2FixtureDef groundFixtureDef;
        groundFixtureDef.shape = &groundEdgeShape;
        
        for (NSArray *pointArray in edgePoints) {
            int stride = FIXTURE_STRIDE;
            for (int i=0; i<[pointArray count]; ++i) {
                if (i % stride != 0) {
                    continue;
                }
                NSValue *pointValue1;
                NSValue *pointValue2;
                if (i < [pointArray count]) {
                    pointValue1 = (NSValue *)[pointArray objectAtIndex:i];
                    int strideLeft = [pointArray count] - i;
                    
                    if (strideLeft > stride) {
                        pointValue2 = (NSValue *)[pointArray objectAtIndex:i+stride];
                    } else {
                        pointValue2 = (NSValue *)[pointArray objectAtIndex:0];
                    }
                    
                    CGPoint pixelPoint1 = [pointValue1 CGPointValue];
                    CGPoint pixelPoint2 = [pointValue2 CGPointValue];
                    BMEdge *edge = [BMEdge edgeWithPixelPoint1:pixelPoint1 pixelPoint2:pixelPoint2];
                    
                    groundFixtureDef.userData = edge;
                    b2Vec2 physicsEdgePoint1 = b2Vec2(edge.point1.x / (CC_CONTENT_SCALE_FACTOR() * PTM_RATIO),
                                                      edge.point1.y / (CC_CONTENT_SCALE_FACTOR() * PTM_RATIO));
                    b2Vec2 physicsEdgePoint2 = b2Vec2(edge.point2.x / (CC_CONTENT_SCALE_FACTOR() * PTM_RATIO),
                                                      edge.point2.y / (CC_CONTENT_SCALE_FACTOR() * PTM_RATIO));
                    groundEdgeShape.Set(physicsEdgePoint1, physicsEdgePoint2);
                    _groundBodyMap[ground.key]->CreateFixture(&groundFixtureDef);
                }
            }
        }
    }
}

- (void)_setupGroundUnitsWithSpritesInfo:(NSArray *)spritesInfo
{
    int debug_count = 0;
    CGFloat debug_duration_in_secs = 0.0;
    
    for (BMSpriteInfo *spriteInfo in spritesInfo) {
        ++debug_count;
        
        // for debug purposes
        if (debug_count < 2) {
            //continue;
        }
        
        BMGround *ground = [BMGround groundWithDelegate:self viewInfo:spriteInfo];
        ground.key = [NSString stringWithFormat:@"key%d", debug_count];
        
        CGFloat reload_duration;
        
        @autoreleasepool {
            reload_duration = [ground reload];
        }        
        
        //debug(@"[4] ### ground reload time (secs): %f", reload_duration);
        
        debug_duration_in_secs += reload_duration;
        
        [_groundUnits addObject:ground];
        
        // for debug purpopses
        if (debug_count == 40) {
            //break;
        }
    }
    //debug(@"[5] ### total setup time (secs): %f", debug_duration_in_secs);
}

- (id)initWithDelegate:(id<BMPhysicsDelegate>)delegate spritesInfo:(NSArray *)spritesInfo
{
    if (self = [super init]) {
        _timeAccumulator = 0.0;
        _delegate = delegate;
        _queuedDamage = [[NSMutableArray alloc] init];
        _queuedParameters = [[NSMutableArray alloc] init];
        _groundUnits = [[NSMutableArray alloc] init];
        
        // does order matter here ? (setting up physics world before reloading ground data)
        [self _initWorld];
        [self _initListener];
        [self _setupGroundUnitsWithSpritesInfo:spritesInfo];
    }
    return self;
}

@end



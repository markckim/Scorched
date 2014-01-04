//
//  TestLayer.m
//  Scorched
//
//  Created by Mark Kim on 11/24/12.
//  Copyright 2012 Mark Kim. All rights reserved.
//

#import "TestLayer.h"

// note: ball.png is 50 x 50 pixels (25 x 25 points on iphone retina)
// note: ball2.png is 20 x 20 pixels (10 x 10 points on iphone retina)
// note: block.png is 10 x 50 pixels (5 x 25 points on iphone retina)

#import "physics_constants.h"

@interface TestLayer ()

- (BOOL)_didFiredBallMakeContactWithGroundForContact:(BMContact)contact;

- (void)_createBall;
- (CCSprite *)_getFiringBall;

- (void)_initPhysics;
- (void)_createPhysicsWorld;
- (void)_createPhysicsWorldEdges;
- (void)_createPhysicsBall;
- (b2Body *)_getPhysicsFiringBallWithUserData:(CCSprite *)userData;
- (void)_fireBallTowardsPoint:(CGPoint)touchPoint;

- (void)_createBlock;
- (void)_createPhysicsBlock;

@end

@implementation TestLayer

- (void)dealloc
{
    delete _world;
    delete _contactListener;
    
    _world = NULL;
    _contactListener = NULL;
    _groundBody = NULL;
    _ballBody = NULL;
    _blockFixture = NULL;
    
    [_ballSprite release]; _ballSprite = nil;
    [_blockSprite release]; _blockSprite = nil;
    
    [super dealloc];
}

- (void)onEnter
{
    CCTouchDispatcher *touchDispatcher = [[CCDirector sharedDirector] touchDispatcher];
    [touchDispatcher addTargetedDelegate:self priority:999 swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit
{
    CCTouchDispatcher *touchDispatcher = [[CCDirector sharedDirector] touchDispatcher];
    [touchDispatcher removeDelegate:self];
    
    [super onExit];
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    TestLayer *layer = [TestLayer node];
    
    [scene addChild:layer];
    
    return scene;
}

- (void)_createBlock
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _blockSprite = [[CCSprite alloc] initWithFile:@"block.png"];
    CGFloat blockSpriteHeight = _blockSprite.contentSize.height;
    _blockSprite.position = ccp(0.5 * winSize.width, 0.5 * blockSpriteHeight);
    
    [self addChild:_blockSprite];
}

- (void)_createPhysicsBlock
{
    // create body def
    // create body on world
    // create shape
    // create fixture def
    // set shape for fixture def
    // create fixture on body
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    b2BodyDef blockBodyDef;
    blockBodyDef.type = b2_dynamicBody;
    blockBodyDef.position = b2Vec2(0.5 * winSize.width / PTM_RATIO, 0.5 * 25.0 / PTM_RATIO);
    blockBodyDef.userData = _blockSprite;
    
    b2Body *blockBody = _world->CreateBody(&blockBodyDef);
    
    b2PolygonShape blockShape;
    // note: SetAsBox takes in parameters that should come out to be HALF the width and height you want the box to be
    blockShape.SetAsBox(0.5 * 5.0 / PTM_RATIO, 0.5 * 25.0 / PTM_RATIO);
    
    b2FixtureDef blockFixtureDef;
    blockFixtureDef.shape = &blockShape;
    blockFixtureDef.density = 1.0f;
    blockFixtureDef.friction = 0.2f;
    blockFixtureDef.restitution = 0.4f;
    
    _blockFixture  = blockBody->CreateFixture(&blockFixtureDef);
}

- (b2Body *)_getPhysicsFiringBallWithUserData:(CCSprite *)userData;
{
    // create body def
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    
    CGFloat firingBallBodyRadius = 0.5 * 10.0 / PTM_RATIO;
    CGFloat ballBodyRadius = 0.5 * 25.0 / PTM_RATIO;
    b2Vec2 positionVec = _ballBody->GetPosition() + b2Vec2(0, firingBallBodyRadius + ballBodyRadius);
    ballBodyDef.position = positionVec;
    
    ballBodyDef.userData = userData;
    
    // create body using body def
    b2Body *ballBody = _world->CreateBody(&ballBodyDef);
    
    // create shape and set its radius
    b2CircleShape circle;
    circle.m_radius = 0.5 * 10.0 / PTM_RATIO;
    
    // create fixture def
    b2FixtureDef ballFixtureDef;
    ballFixtureDef.shape = &circle;
    ballFixtureDef.density = 1.0f;
    ballFixtureDef.friction = 0.2f;
    ballFixtureDef.restitution = 0.8f;    
    
    // create fixture on body
    ballBody->CreateFixture(&ballFixtureDef);
    
    // add body to array
    _spriteBodies.push_back(ballBody);
    
    return ballBody;
}

- (void)_createPhysicsBall
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // create a body definition, set type, position, userData
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    
//    ballBodyDef.position.Set(0.5*winSize.width/PTM_RATIO, 0.5*winSize.height/PTM_RATIO);
    CGFloat ballRadius = 0.5 * _ballSprite.contentSize.width;
    ballBodyDef.position.Set(0.2 * winSize.width/PTM_RATIO, ballRadius/PTM_RATIO);
    
    ballBodyDef.userData = _ballSprite;
    
    // create a body using body definition
    _ballBody = _world->CreateBody(&ballBodyDef);
    
    // create a circle shape and set its radius
    b2CircleShape circle;
    circle.m_radius = 0.5 * 25.0 / PTM_RATIO;
    
    // create a fixture def
    b2FixtureDef ballFixtureDef;
    ballFixtureDef.shape = &circle;
    ballFixtureDef.density = 1.0f;
    ballFixtureDef.friction = 0.2f;
    ballFixtureDef.restitution = 0.8f;
    
    // create fixture on _ballBody
    _ballBody->CreateFixture(&ballFixtureDef);
}

- (void)_createPhysicsWorldEdges
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // create a body definition and set its position
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    
    // create a body using the body definition
    _groundBody = _world->CreateBody(&groundBodyDef);
    
    // create a shape
    b2EdgeShape groundEdgeShape;
    
    // create a fixture definition and set its shape
    b2FixtureDef boxFixtureDef;
    boxFixtureDef.shape = &groundEdgeShape;
    
    // create fixture on _groundBody
    groundEdgeShape.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO,0));
    _bottomGroundFixture = _groundBody->CreateFixture(&boxFixtureDef);
    
    // create fixture on _groundBody
    groundEdgeShape.Set(b2Vec2(0,0), b2Vec2(0,winSize.height/PTM_RATIO));
    _leftGroundFixture = _groundBody->CreateFixture(&boxFixtureDef);
    
    // create fixture on _groundBody
    groundEdgeShape.Set(b2Vec2(0,winSize.height/PTM_RATIO),
                        b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO));
    _topGroundFixture = _groundBody->CreateFixture(&boxFixtureDef);
    
    // create fixture on _groundBody
    groundEdgeShape.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO),
                        b2Vec2(winSize.width/PTM_RATIO, 0));
    _rightGroundFixture = _groundBody->CreateFixture(&boxFixtureDef);
}

- (void)_createPhysicsWorld
{
    b2Vec2 gravity = b2Vec2(0.0, -10.0);
    _world = new b2World(gravity);
    
    _contactListener = new BMContactListener();
    _world->SetContactListener(_contactListener);
}

- (void)_initPhysics
{
    // initialize world with gravity and a contact listener
    [self _createPhysicsWorld];
    
    // create edges around the screen
    [self _createPhysicsWorldEdges];
    
    // create a main ball to launch little balls from
    [self _createPhysicsBall];
    
    // create a block that can be hit
    [self _createPhysicsBlock];
}

- (void)_fireBallTowardsPoint:(CGPoint)touchLocation
{
    // create ball sprite and add as child    
    CCSprite *firingBallSprite = [self _getFiringBall];
    [self addChild:firingBallSprite];
    
    // create physics ball and add it to the world
    b2Body *firingBallBody = [self _getPhysicsFiringBallWithUserData:firingBallSprite];
    
    // apply impulse
    CGPoint unitVector = [TestLayer unitVectorFrom:_ballSprite.position To:touchLocation];
    
    b2Vec2 impulsePosition = firingBallBody->GetPosition();
    
    firingBallBody->ApplyLinearImpulse(b2Vec2(0.75 * unitVector.x, 0.75 * unitVector.y), impulsePosition);
}

- (CCSprite *)_getFiringBall
{
    CCSprite *firingBallSprite = [CCSprite spriteWithFile:@"ball2.png"];
    
    CGFloat firingBallRadius = 0.5 * firingBallSprite.contentSize.width;
    CGFloat mainBallRadius = 0.5 * _ballSprite.contentSize.width;
    
    // set to at the top of the main ball
    CGPoint firingBallPosition = CGPointMake(_ballSprite.position.x,
                                             _ballSprite.position.y + mainBallRadius + firingBallRadius);
    
    firingBallSprite.position = firingBallPosition;
    firingBallSprite.tag = 99;
    
    return firingBallSprite;
}

- (void)_createBall
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _ballSprite = [[CCSprite alloc] initWithFile:@"ball.png"];
    
//    _ballSprite.position = ccp(0.5*winSize.width, 0.5*winSize.height);
    CGFloat ballRadius = 0.5 * _ballSprite.contentSize.width;
    _ballSprite.position = ccp(0.2 * winSize.width, ballRadius);
    
    [self addChild:_ballSprite];
}

- (void)update:(ccTime)delta
{
    _accumulator += delta;
    
    while (_accumulator >= FIXED_TIME_STEP)
    {
        _accumulator -= FIXED_TIME_STEP;
        _world->Step(FIXED_TIME_STEP, 10, 10);
        
        // update world
        for (b2Body *body = _world->GetBodyList(); body; body = body->GetNext())
        {
            if (body->GetUserData())
            {
                CCSprite *sprite = (CCSprite *)body->GetUserData();
                
                CGPoint newPositionPoint = ccp(body->GetPosition().x * PTM_RATIO,
                                               body->GetPosition().y * PTM_RATIO);
                
                sprite.position = newPositionPoint;
                sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
            }
        }
        
        // detect collisions and add sprite bodies to destroy
        std::vector<BMContact>::iterator pos;
        for (pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos)
        {            
            if ([self _didFiredBallMakeContactWithGroundForContact:*pos])
            {
                CCLOG(@"ground contacted");
            }
        }
        
        // destroy balls that have collided with the bottom ground
        std::vector<b2Body*>::iterator pos2;
        for (pos2 = _spriteBodiesToDestroy.begin(); pos2 != _spriteBodiesToDestroy.end(); ++pos2)
        {
            b2Body *body = *pos2;
            CCSprite *sprite = (CCSprite *)body->GetUserData();
            
            if (sprite)
            {
                [self removeChild:sprite cleanup:YES];
            }
            _world->DestroyBody(body);
        }
        _spriteBodiesToDestroy.clear();
    }
}

- (BOOL)_didFiredBallMakeContactWithGroundForContact:(BMContact)contact
{
    std::vector<b2Body*>::iterator pos;
    for (pos = _spriteBodies.begin(); pos != _spriteBodies.end(); ++pos)
    {
        b2Body *body = *pos;
        
        for (b2Fixture *fixture = body->GetFixtureList(); fixture; fixture = fixture->GetNext())
        {
            BOOL isGroundContact = contact.fixtureA == _bottomGroundFixture || contact.fixtureB == _bottomGroundFixture;
            BOOL isBallContact = contact.fixtureA == fixture || contact.fixtureB == fixture;
            
            // check if fired ball has contacted block; if so, calculate the force
            BOOL isBlockContact = contact.fixtureA == _blockFixture || contact.fixtureB == _blockFixture;
            
            if (isBlockContact && isBallContact)
            {
                CCLOG(@"fired ball hit block with force: %f", contact.force);
            }
            
            if (isGroundContact && isBallContact)
            {
                // mark body for destruction later
                if (std::find(_spriteBodiesToDestroy.begin(), _spriteBodiesToDestroy.end(), body) == _spriteBodiesToDestroy.end())
                {
                    _spriteBodiesToDestroy.push_back(body);
                    pos = _spriteBodies.erase(pos);
                }
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCDirector *director = [CCDirector sharedDirector];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    CGPoint glTouchLocation = [director convertToGL:touchLocation];
    
    CCLOG(@"touchLocation: %f, %f", glTouchLocation.x, glTouchLocation.y);
    
    [self _fireBallTowardsPoint:glTouchLocation];
    
    return YES;
}

+ (CGPoint)unitVectorFrom:(CGPoint)startingPoint To:(CGPoint)endingPoint
{
    CGFloat lengthX = endingPoint.x - startingPoint.x;
    CGFloat lengthY = endingPoint.y - startingPoint.y;
    CGFloat vectorLength = sqrtf(powf(lengthX,2) + powf(lengthY,2));
    
    return CGPointMake(lengthX / vectorLength, lengthY / vectorLength);
}

- (id)init
{
    if (self=[super init])
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCLOG(@"screenSize: %f, %f", screenSize.width, screenSize.height);
        
        _accumulator = 0.0f;
        _contactListener = new BMContactListener();
        
        [self _createBall];
        [self _createBlock];
        [self _initPhysics];
        
        [self scheduleUpdate];
    }
    return self;
}

@end

























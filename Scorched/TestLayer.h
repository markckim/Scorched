//
//  TestLayer.h
//  Scorched
//
//  Created by Mark Kim on 11/24/12.
//  Copyright 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "BMContactListener.h"

@interface TestLayer : CCLayer <CCTargetedTouchDelegate>
{
    b2World *_world;
    b2Body *_groundBody;
    b2Body *_ballBody;
    CCSprite *_ballSprite;
    CCSprite *_blockSprite;
    
    // block fixture reference
    b2Fixture *_blockFixture;
    
    // ground fixture references
    b2Fixture *_rightGroundFixture;
    b2Fixture *_leftGroundFixture;
    b2Fixture *_topGroundFixture;
    b2Fixture *_bottomGroundFixture;
    
    CGFloat _accumulator;
    
    BMContactListener *_contactListener;
        
    std::vector<b2Body*> _spriteBodies;
    std::vector<b2Body*> _spriteBodiesToDestroy;
}

+ (CCScene *)scene;

+ (CGPoint)unitVectorFrom:(CGPoint)startingPoint To:(CGPoint)endingPoint;

@end

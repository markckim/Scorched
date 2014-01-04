//
//  game_protocols.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "cocos2d.h"

@protocol BMHealthBarDelegate <NSObject>
@property (nonatomic, assign) int currentHealth;
@property (nonatomic, assign) int maxHealth;
@end

@protocol BMTouchViewDelegate <NSObject>
- (void)didTapLocation:(CGPoint)touchLocation;
- (void)didTranslateBy:(CGPoint)translation;
- (void)didEndPanWithVelocity:(CGPoint)touchVelocity;
- (void)didScaleBy:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation;
@end

@protocol BMTestTouchViewDelegate <NSObject>
- (void)didTapLocation:(CGPoint)touchLocation;
- (void)didTranslateBy:(CGPoint)translation;
- (void)didScaleBy:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation;
@end

@class BMGround;
@protocol BMGroundDelegate <NSObject>
- (void)ground:(BMGround *)ground didReloadData:(NSArray *)edgePoints;
@end

#ifdef __cplusplus
#import "Box2D.h"
@protocol BMPhysicsDelegate
- (void)willDestroyBodyFixtureWithUserData:(id)userData;
- (void)didDestroyBodyFixtureWithUserData:(id)userData;
- (void)didUpdatePositionForBody:(b2Body *)body;
- (void)bodyDidContactGround:(b2Body *)body;
- (void)body:(b2Body *)body1 didContactOtherBody:(b2Body *)body2;
@end
#endif
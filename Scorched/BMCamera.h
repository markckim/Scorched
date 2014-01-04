//
//  BMCamera.h
//  Scorched
//
//  Created by Mark Kim on 5/4/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMCamera : BMModel

- (void)setVelocity:(CGPoint)velocity;
- (void)panWithTranslation:(CGPoint)translation;
- (void)scaleWithAmount:(CGFloat)scaleAmount touchLocation:(CGPoint)touchLocation;
- (id)initWithWorldViews:(NSArray *)worldViews;

@end
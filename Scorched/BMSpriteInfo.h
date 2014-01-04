//
//  BMSpriteInfo.h
//  Scorched
//
//  Created by Mark Kim on 5/5/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@interface BMSpriteInfo : BMViewModel

@property (nonatomic, assign) CGPoint finalPosition;

- (id)initWithView:(CCSprite *)view finalPosition:(CGPoint)finalPosition;

@end

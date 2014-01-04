//
//  BMViewModel.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMViewModel : BMModel

@property (nonatomic, retain) CCSprite *view;

- (id)initWithView:(CCSprite *)view;

@end

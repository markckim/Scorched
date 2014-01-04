//
//  BMModel.h
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "game_constants.h"
#import "game_protocols.h"

@interface BMModel : CCNode

@property (nonatomic, assign) int modelId;
@property (nonatomic, assign) BMModelType modelType;

+ (Class)getModelClass;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end

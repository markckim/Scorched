//
//  BMDebugModel.m
//  Scorched
//
//  Created by Mark Kim on 3/17/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMDebugModel.h"

@implementation BMDebugModel

- (id)init
{
    if (self = [super init]) {
        self.modelType = kDebugModel;
    }
    return self;
}

@end

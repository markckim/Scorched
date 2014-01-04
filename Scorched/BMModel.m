//
//  BMModel.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@implementation BMModel

- (void)dealloc
{
    [super dealloc];
}

- (void)cleanup
{
    CCLOG(@"BMModel, cleanup method called");
    [super cleanup];
}

+ (Class)getModelClass
{
    return [self class];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _modelId = [[dictionary objectForKey:@"model_id"] intValue];
        _modelType = [[dictionary objectForKey:@"model_type"] intValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:_modelId] forKey:@"model_id"];
    [dictionary setObject:[NSNumber numberWithInt:_modelType] forKey:@"model_type"];
    
    return dictionary;
}

- (id)init
{
    if (self = [super init]) {
        _modelId = 0;
        _modelType = kModelTypeNone;
    }
    return self;
}

@end













//
//  BMDevice.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMDevice.h"

@implementation BMDevice

- (void)dealloc
{
    [_deviceId release]; _deviceId = nil;
    [_deviceType release]; _deviceType = nil;
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        _deviceId = [[dictionary objectForKey:@"id"] copy];
        _deviceType = [[dictionary objectForKey:@"type"] copy];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dictionary setObject:_deviceId forKey:@"id"];
    [dictionary setObject:_deviceType forKey:@"type"];
    
    return dictionary;
}

@end

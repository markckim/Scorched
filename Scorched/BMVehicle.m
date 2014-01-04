//
//  BMVehicle.m
//  Scorched
//
//  Created by Mark Kim on 12/2/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMVehicle.h"

@implementation BMVehicle

- (void)update:(ccTime)delta
{
    // do stuff
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        _armor = [[dictionary objectForKey:@"armor"] intValue];
        _magicResistance = [[dictionary objectForKey:@"magic_resistance"] intValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dictionary setObject:[NSNumber numberWithInt:_armor] forKey:@"armor"];
    [dictionary setObject:[NSNumber numberWithInt:_magicResistance] forKey:@"magic_resistance"];
    
    return dictionary;
}

@end








//
//  BMNameLabel.h
//  Scorched
//
//  Created by Mark Kim on 1/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMViewModel.h"

@interface BMNameLabel : BMViewModel

@property (nonatomic, copy) NSString *name;

- (id)initWithName:(NSString *)name;

@end

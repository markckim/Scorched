//
//  BMDevice.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMDevice : BMModel

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceType;

@end

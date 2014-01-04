//
//  BMPixelInfo.h
//  Scorched
//
//  Created by Mark Kim on 4/10/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMPixelInfo : BMModel

@property (nonatomic, assign) BOOL isClear;
@property (nonatomic, assign) BOOL isSurface;

+ (id)info;

@end

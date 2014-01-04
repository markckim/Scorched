//
//  BMModelHelper.h
//  Scorched
//
//  Created by Mark Kim on 12/5/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"

@interface BMModelHelper : BMModel

+ (Class)getClassForModelType:(BMModelType)modelType;

@end

//
//  BMTestController.h
//  Scorched
//
//  Created by Mark Kim on 4/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMController.h"

@class BMTestView;
@class BMTestTouchView;

@interface BMTestController : BMController <BMTestTouchViewDelegate>

@property (nonatomic, retain) CCMenuItemFont *backMenuButton;
@property (nonatomic, retain) BMTestView *testView;
@property (nonatomic, retain) BMTestTouchView *testTouchView;

@end

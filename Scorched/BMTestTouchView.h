//
//  BMTestTouchView.h
//  Scorched
//
//  Created by Mark Kim on 4/18/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMView.h"

@interface BMTestTouchView : BMView <UIGestureRecognizerDelegate>

- (id)initWithDelegate:(id<BMTestTouchViewDelegate>)delegate;

@end

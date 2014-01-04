//
//  BMSplashController.h
//  Scorched
//
//  Created by Mark Kim on 12/27/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMController.h"
#import "ASIHTTPRequestDelegate.h"

@class BMSplashView;

@interface BMSplashController : BMController <ASIHTTPRequestDelegate>

@property (nonatomic, retain) BMSplashView *view;

@end

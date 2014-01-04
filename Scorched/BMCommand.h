//
//  BMCommand.h
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMModel.h"
#import "ASIHTTPRequestDelegate.h"
#import "server_constants.h"

@interface BMCommand : BMModel

@property (nonatomic, assign) id<ASIHTTPRequestDelegate> delegate;
@property (nonatomic, assign) BMAPIMessageType messageType;
@property (nonatomic, retain) NSDictionary *parameters;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) SEL didFailSelector;

- (void)send;

+ (id)commandWithDelegate:(id<ASIHTTPRequestDelegate>)delegate;
- (id)initWithDelegate:(id<ASIHTTPRequestDelegate>)delegate;

@end

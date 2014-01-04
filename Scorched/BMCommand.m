//
//  BMCommand.m
//  Scorched
//
//  Created by Mark Kim on 12/26/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMCommand.h"
#import "BMServiceManager.h"

@implementation BMCommand

- (void)dealloc
{
    [_parameters release]; _parameters = nil;
    _delegate = nil;
    _didFinishSelector = nil;
    _didFailSelector = nil;
    [super dealloc];
}

- (void)send
{
    [[BMServiceManager sharedInstance] sendRequestWithCommand:self];
}

+ (id)commandWithDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

- (id)initWithDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _messageType = kAPIMessageTypeNone;
        _parameters = nil;
        _didFinishSelector = nil;
        _didFailSelector = nil;
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        _delegate = nil;
        _messageType = kAPIMessageTypeNone;
        _parameters = nil;
        _didFinishSelector = nil;
        _didFailSelector = nil;
    }
    return self;
}

@end

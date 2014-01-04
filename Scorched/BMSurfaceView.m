//
//  BMSurfaceView.m
//  Scorched
//
//  Created by Mark Kim on 1/6/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMSurfaceView.h"
#import "BMSpriteInfo.h"

@interface BMSurfaceView ()

@property (nonatomic, retain) NSArray *sprites;

- (void)_initView;

@end

@implementation BMSurfaceView

- (void)dealloc
{
    [_sprites release]; _sprites = nil;
    [super dealloc];
}

- (void)_initView
{
    if (DRAW_GROUND) {
        
        int debug_count = 0;
        if (_sprites && [_sprites count] > 0) {
            for (BMSpriteInfo *spriteInfo in _sprites) {
                ++debug_count;
                
                if (debug_count < 1) {
                    //continue;
                }
                
                [self.view addChild:spriteInfo.view z:1];
                
                if (debug_count == 1) {
                    //break;
                }
            }
        }
    }
}

- (id)initWithSprites:(NSArray *)sprites
{
    if (self = [super init]) {        
        _sprites = [sprites retain];
        [self _initView];
    }
    return self;
}

@end















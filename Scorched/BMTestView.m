//
//  BMTestView.m
//  Scorched
//
//  Created by Mark Kim on 4/3/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMTestView.h"
#import "util_functions.h"

#define TEST_STEPS 5000

@interface BMTestView ()

- (BOOL)_isPixelClear:(uint8[4])data;

@end

@implementation BMTestView

- (void)dealloc
{
    [_testSprite release]; _testSprite = nil;
    
    [super dealloc];
}

- (BOOL)_isPixelClear:(uint8[4])data
{
    // note: assumes data is RGBA format
    BOOL isPixelClear = NO;
    if (data[3] == 0) {
        isPixelClear = YES;
    }
    return isPixelClear;
}

- (void)_benchmarkTexApplyPixels
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCTexture2DMutable *tex = (CCTexture2DMutable *)_testSprite.texture;
    
    NSDate *start1 = [NSDate date];
    int debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        if (CCRANDOM_0_1() >= 0.5) {
            [tex setPixelAt:testPixelPoint rgba:ccc4(0, 0, 0, 0)];
        } else {
            [tex setPixelAt:testPixelPoint rgba:ccc4(1, 1, 1, 1)];
        }
        ++debug_count;
    }
    //[tex apply];
    CGFloat time1 = fabs([start1 timeIntervalSinceNow]);
    debug(@"[4] tex_set + no_tex_apply::: steps: %d time %f", debug_count, time1);
        
    NSDate *start2 = [NSDate date];
    debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        if (CCRANDOM_0_1() >= 0.5) {
            [tex setPixelAt:testPixelPoint rgba:ccc4(0, 0, 0, 0)];
        } else {
            [tex setPixelAt:testPixelPoint rgba:ccc4(1, 1, 1, 1)];
        }
        [tex apply];
        ++debug_count;
    }
    CGFloat time2 = fabs([start2 timeIntervalSinceNow]);
    debug(@"[4] tex_set + tex_apply::: steps: %d time %f", debug_count, time2);
}

- (void)_benchmarkDictionaryPixels
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    NSMutableDictionary *pixelDict = [NSMutableDictionary dictionary];
    
    NSDate *start1 = [NSDate date];
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:winSize.width
                                                                     height:winSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    uint8 data[4];
    [renderTexture beginWithClear:0 g:0 b:0 a:0];
    
    [_testSprite visit];
    
    NSDate *start2 = [NSDate date];
    int debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        glReadPixels(testPixelPoint.x, testPixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
        BOOL isPixelClear = [self _isPixelClear:data];
        [pixelDict setObject:[NSNumber numberWithBool:isPixelClear] forKey:stringForPoint(testPixelPoint)];
        ++debug_count;
    }
    CGFloat time2 = fabs([start2 timeIntervalSinceNow]);
    debug(@"[3] gl_read_pixels + setObject::: steps: %d time: %f", debug_count, time2);
    
    [renderTexture end];
    [renderTexture release];
    CGFloat time1 = fabs([start1 timeIntervalSinceNow]);
    debug(@"[3] gl_read_pixels + setObject + render::: steps: %d time: %f DIFF: %f", debug_count, fabs([start1 timeIntervalSinceNow]), time1 - time2);
    
    NSDate *start3 = [NSDate date];
    debug_count = 0;
    while (debug_count < TEST_STEPS) {
        int randomX = (int)roundf(CCRANDOM_0_1() * (TEST_STEPS - 1));
        int randomY = (int)roundf(CCRANDOM_0_1() * (TEST_STEPS - 1));
        [[pixelDict objectForKey:stringForPoint(ccp(randomX, randomY))] boolValue];
        ++debug_count;
    }
    CGFloat time3 = fabs([start3 timeIntervalSinceNow]);
    debug(@"[3] read_dict::: steps: %d time: %f", debug_count, time3);
}

- (void)_benchmarkArrayPixels
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    NSMutableArray *pixelArray = [NSMutableArray array];
    
    NSDate *start1 = [NSDate date];
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:winSize.width
                                                                     height:winSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    uint8 data[4];
    [renderTexture beginWithClear:0 g:0 b:0 a:0];
    
    [_testSprite visit];
    
    NSDate *start2 = [NSDate date];
    int debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        glReadPixels(testPixelPoint.x, testPixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
        BOOL isPixelClear = [self _isPixelClear:data];
        [pixelArray addObject:[NSNumber numberWithBool:isPixelClear]];
        ++debug_count;
    }
    CGFloat time2 = fabs([start2 timeIntervalSinceNow]);
    debug(@"[2] gl_read_pixels + addObject::: steps: %d time: %f", debug_count, time2);
    
    [renderTexture end];
    [renderTexture release];
    CGFloat time1 = fabs([start1 timeIntervalSinceNow]);
    debug(@"[2] gl_read_pixels + addObject + render::: steps: %d time: %f DIFF: %f", debug_count, fabs([start1 timeIntervalSinceNow]), time1 - time2);
    
    NSDate *start3 = [NSDate date];
    debug_count = 0;
    while (debug_count < TEST_STEPS) {
        int randomIndex = (int)roundf(CCRANDOM_0_1() * (TEST_STEPS - 1));
        [[pixelArray objectAtIndex:randomIndex] boolValue];
        ++debug_count;
    }
    CGFloat time3 = fabs([start3 timeIntervalSinceNow]);
    debug(@"[2] read_array::: steps: %d time: %f", debug_count, time3);
}

- (void)_benchmarkReadPixels
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSDate *start1 = [NSDate date];
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:winSize.width
                                                                     height:winSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    uint8 data[4];
    [renderTexture beginWithClear:0 g:0 b:0 a:0];
    
    [_testSprite visit];
    
    NSDate *start2 = [NSDate date];
    int debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        glReadPixels(testPixelPoint.x, testPixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
        [self _isPixelClear:data];
        ++debug_count;
    }
    CGFloat time2 = fabs([start2 timeIntervalSinceNow]);
    debug(@"[1] gl_read_pixels: steps::: %d time: %f", debug_count, time2);
    
    [renderTexture end];
    [renderTexture release];
    CGFloat time1 = fabs([start1 timeIntervalSinceNow]);
    debug(@"[1] gl_read_pixels + renderTexture: steps::: %d time: %f DIFF: %f", debug_count, fabs([start1 timeIntervalSinceNow]), time1 - time2);
}

- (void)_benchmarkReplaceObjectArrayPixels
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    NSMutableArray *pixelArray = [NSMutableArray array];
    
    NSDate *start1 = [NSDate date];
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:winSize.width
                                                                     height:winSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    uint8 data[4];
    [renderTexture beginWithClear:0 g:0 b:0 a:0];
    
    [_testSprite visit];
    
    NSDate *start2 = [NSDate date];
    int debug_count = 0;
    while (debug_count < TEST_STEPS) {
        CGPoint testPixelPoint = ccp(CCRANDOM_0_1() * winSize.width * CC_CONTENT_SCALE_FACTOR(),
                                     CCRANDOM_0_1() * winSize.height * CC_CONTENT_SCALE_FACTOR());
        glReadPixels(testPixelPoint.x, testPixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
        BOOL isPixelClear = [self _isPixelClear:data];
        [pixelArray addObject:[NSNumber numberWithBool:isPixelClear]];
        ++debug_count;
    }
    CGFloat time2 = fabs([start2 timeIntervalSinceNow]);
    debug(@"[5] gl_read_pixels + addObject::: steps: %d time: %f", debug_count, time2);
    
    [renderTexture end];
    [renderTexture release];
    CGFloat time1 = fabs([start1 timeIntervalSinceNow]);
    debug(@"[5] gl_read_pixels + addObject + render::: steps: %d time: %f DIFF: %f", debug_count, fabs([start1 timeIntervalSinceNow]), time1 - time2);
    
    NSDate *start3 = [NSDate date];
    debug_count = 0;
    while (debug_count < TEST_STEPS) {
        int randomIndex = (int)roundf(CCRANDOM_0_1() * (TEST_STEPS - 1));
        [pixelArray replaceObjectAtIndex:randomIndex withObject:@YES];
        ++debug_count;
    }
    CGFloat time3 = fabs([start3 timeIntervalSinceNow]);
    debug(@"[5] replace_object_array::: steps: %d time: %f", debug_count, time3);
}

- (void)_setupView
{
    UIImage *testImage = [UIImage imageNamed:TEST_IMAGE_NAME];
    NSArray *testSprites = positionedSpritesFromImage(testImage, IMAGE_PIXEL_STEP_X, IMAGE_PIXEL_STEP_Y);
    
    for (CCSprite *sprite in testSprites) {
        [self addChild:sprite z:99];
    }
}

- (void)_runTests
{
    NSAssert(_testSprite, @"ERROR: cannot run tests if _testSprite is nil!");
    
    // glReadPixels test
    [self _benchmarkReadPixels];
        
    // NSMutableArray read test
    [self _benchmarkArrayPixels];
    
    // NSMutableArray replace test
    [self _benchmarkReplaceObjectArrayPixels];
    
    // NSMutableDictionary test
    [self _benchmarkDictionaryPixels];
    
    // CCTexture2DMutable apply test
    //[self _benchmarkTexApplyPixels];
}

- (void)_setupTestSprite
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGImageRef imageRef = [[UIImage imageNamed:TEST_IMAGE_NAME] CGImage];
    CCTexture2DMutable *tex = [[CCTexture2DMutable alloc] initWithCGImage:imageRef
                                                           resolutionType:kCCResolutioniPhoneRetinaDisplay];
    _testSprite = [[CCSprite alloc] initWithTexture:tex];
    _testSprite.position = ccp(0.5 * winSize.width, 0.5 * winSize.height);
}

- (void)_testView
{
    CCSprite *sprite = [CCSprite spriteWithFile:TEST_IMAGE_NAME];
    CGSize viewSize = sprite.contentSize;
    sprite.position = ccp(0.5 * viewSize.width, 0.5 * viewSize.height);
    [self addChild:sprite];
}

- (void)_testView2
{
    NSString *imageString = TEST_IMAGE_NAME;
    CGImageRef imageRef = [[UIImage imageNamed:imageString] CGImage];
    CCTexture2DMutable *tex = [[CCTexture2DMutable alloc] initWithCGImage:imageRef
                                                           resolutionType:kCCResolutioniPhoneRetinaDisplay];
    self.testSprite = [CCSprite spriteWithTexture:tex];
    CGSize viewSize = _testSprite.contentSize;
    _testSprite.position = ccp(0.5 * viewSize.width, 0.5 * viewSize.height);
    [self addChild:_testSprite];
}

- (id)init
{
    if (self = [super init]) {
        //[self _setupTestSprite];
        //[self _runTests];
        //[self _testView];
        [self _testView2];
    }
    return self;
}

@end

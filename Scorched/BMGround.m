//
//  BMGround.m
//  Scorched
//
//  Created by Mark Kim on 3/5/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#import "BMGround.h"

#import "BMEdge.h"
#import "BMDamage.h"
#import "BMDebugView.h"
#import "BMPixelInfo.h"
#import "BMPoint.h"
#import "CCMutableTexture2D.h"
#import "BMSpriteInfo.h"
#import <OpenGLES/EAGL.h>

#import "util_functions.h"

@interface BMGround ()
{
    int                     surface_debug_count;
    int                     read_pixel_debug_count;
    NSMutableArray          *_pixelData;
    id<BMGroundDelegate>    _delegate;
    BMSpriteInfo            *_spriteInfo;
}

- (CGFloat)_setupData;
- (CGFloat)_reloadData;
- (void)_resetSurfaces;
- (void)_reloadSurfaces;
- (void)_setSurfaces:(CGPoint)point;
- (NSArray *)_createSurfaceForEdgePoint:(BMPoint *)edgePoint;

- (NSArray *)_getLines;
- (BOOL)_isPixelClear:(uint8[4])data;

@end

@implementation BMGround

- (void)dealloc
{
    [_key release]; _key = nil;
    [_spriteInfo release]; _spriteInfo = nil;
    [_pixelData release]; _pixelData = nil;
    [_edgePoints release]; _edgePoints = nil;
    _delegate = nil;
    
    [super dealloc];
}

- (BOOL)_isPixelClear:(uint8[4])data
{
    // note: asumes data is RGBA format
    BOOL isPixelClear = NO;
    if (data[3] == 0) {
        isPixelClear = YES;
    }
    return isPixelClear;
}

- (NSArray *)_getLines;
{
    NSAssert(self.view, @"ERROR: view is not set!");
    
    CGRect viewRect = pixelRectForSprite(self.view, 0);
    int offsetX = (int)viewRect.origin.x;
    int offsetY = (int)viewRect.origin.y;
    int widthInPixels = (int)viewRect.size.width;
    int heightInPixels = (int)viewRect.size.height;
    //debug(@"offsetX: %d, offsetY: %d, widthInPixels: %d, heightInPixels: %d", offsetX, offsetY, widthInPixels, heightInPixels);
    
    NSMutableArray *lines = [NSMutableArray array];
    for (int i = 1 + offsetY; i <= (heightInPixels + offsetY); i = MIN(i + PIXEL_STEP_Y, heightInPixels + offsetY)) {
        NSMutableArray *pixelsOnLine = [NSMutableArray array];
        [lines addObject:pixelsOnLine];
        for (int j = 1 + offsetX; j <= (widthInPixels + offsetX); j = MIN(j + PIXEL_STEP_X, widthInPixels + offsetX)) {
            CGPoint pixelPoint = ccp(j - 1, i - 1);
            [pixelsOnLine addObject:[NSValue valueWithCGPoint:pixelPoint]];
            //debug(@"pixel added: %f, %f", pixelPoint.x, pixelPoint.y);
            if (j == widthInPixels + offsetX) break;
        }
        //debug(@"# of pixels per line: %d", [pixelsOnLine count]);
        if (i == heightInPixels + offsetY) break;
    }
    //debug(@"# of lines: %d", [lines count]);
    return lines;
}

- (void)_setSurfaces:(CGPoint)point
{
    CGRect viewRect = pixelRectForSprite(self.view, 0);
    int threshold = MAX(NEIGHBOR_STEP - 1, 0);
    for (int i=-threshold; i<=threshold; ++i) {
        for (int j=-threshold; j<=threshold; ++j) {
            CGPoint deltaPoint = ccp(j, i);
            CGPoint testPoint = ccpAdd(point, deltaPoint);
            int index = indexForPoint(testPoint, viewRect);
            
            // this will catch points on edge
            if (index >= 0 && index < [_pixelData count]) {
                BMPixelInfo *pixelInfo = (BMPixelInfo *)[_pixelData objectAtIndex:index];
                pixelInfo.isSurface = YES;
            }
        }
    }
}

- (NSArray *)_createSurfaceForEdgePoint:(BMPoint *)edgePoint
{
    //debug(@"=== [%d] creating surface at point: %@!", surface_debug_count, stringForPoint(edgePoint.point));
    CGRect viewRect = pixelRectForSprite(self.view, 0);
    ++surface_debug_count;
    int edge_debug_count = 0;
    int neighbor_debug_count = 0;
    
    NSMutableArray *pointArray = [NSMutableArray array];
    BMPoint *point = edgePoint;
    addPointToArray(edgePoint.point, pointArray);
    
    BOOL isSurfaceClosed = NO;
    while (!isSurfaceClosed) {
        ++neighbor_debug_count;
        CGPoint testPixelPoint = [point nextNeighbor];
        
        // TODO: - Mark Kim - if possible, find a cleaner way to do this check
        if (neighbor_debug_count > 7) {
            /*
             * this can happen if:
             * we begin on a pixel with no other pixels surrounding it
             * not sure if there are any other strange cases where this could happen
             */
            //debug(@"WARNING: neighbor_debug_count exceeded 7!");
            return pointArray;
        }
        
        if (isPixelOutsideView(testPixelPoint, self.view)) {
            continue;
        }
        
        BMPixelInfo *pixelInfo = (BMPixelInfo *)[_pixelData objectAtIndex:indexForPoint(testPixelPoint, viewRect)];
        if (pixelInfo.isClear) {
            continue;
        } else {
            //debug(@"+ adding edge: %@ to %@", stringForPoint(point.point), stringForPoint(testPixelPoint));
            ++edge_debug_count;
            
            [self _setSurfaces:point.point];
            addPointToArray(testPixelPoint, pointArray);
            
            neighbor_debug_count = 0;
            point = [BMPoint pointWithPixelPoint:testPixelPoint fromDirection:point.relativeDirection];
            
            // test if end point reached
            int x1 = (int)roundf(point.point.x);
            int y1 = (int)roundf(point.point.y);
            int x2 = (int)roundf(edgePoint.point.x);
            int y2 = (int)roundf(edgePoint.point.y);
            int threshold = MAX(NEIGHBOR_STEP - 1, 0);
            if (abs(x2 - x1) <= threshold && abs(y2 - y1) <= threshold) {
                isSurfaceClosed = YES;
            }
            
            if (CGPointEqualToPoint(point.point, edgePoint.point)) {
                isSurfaceClosed = YES;
            }
        }
        
        if (isSurfaceClosed) {
            //debug(@"closing surface with %d edges! current surface count: %d", edge_debug_count, surface_debug_count);
        }
    }
    return pointArray;
}

- (void)_resetSurfaces
{
    [_edgePoints removeAllObjects];
    for (BMPixelInfo *pixelInfo in _pixelData) {
        pixelInfo.isSurface = NO;
    }
}

- (void)_reloadSurfaces
{
    // flush out old data
    [self _resetSurfaces];
    
    NSAssert(self.view, @"ERROR: view is not set!");
    CGRect viewRect = pixelRectForSprite(self.view, 0);
    
    NSArray *lines = [self _getLines];
    surface_debug_count = 0;
    int debug_line_count = 0;
    int debug_point_count = 0;
    
    for (NSArray *line in lines) {
        ++debug_line_count;
        debug_point_count = 0;
        
        // note: for every line, isPixelClear is only updated when it is left edge or right edge,
        // note: or if we get to a point where pixel alpha differs from previous point
        NSNumber *isPixelClear = nil;
        
        for (int i=0; i<[line count]; ++i) {
            ++debug_point_count;
            CGPoint testPixelPoint = [[line objectAtIndex:i] CGPointValue];
            BMPixelInfo *pixelInfo = (BMPixelInfo *)[_pixelData objectAtIndex:indexForPoint(testPixelPoint, viewRect)];
            BMPoint *edgePoint = nil;
            
            // left edge case
            if (!isPixelClear) {
                isPixelClear = [NSNumber numberWithBool:pixelInfo.isClear];
                if (![isPixelClear boolValue]) {
                    edgePoint = [BMPoint pointWithPixelPoint:testPixelPoint fromDirection:kWest];
                }
            // normal case
            } else if ([isPixelClear boolValue] != pixelInfo.isClear) {
                isPixelClear = [NSNumber numberWithBool:pixelInfo.isClear];
                CGPoint prevPixelPoint = [[line objectAtIndex:i-1] CGPointValue];
                edgePoint = solidPointBetweenPixelPoints(prevPixelPoint, testPixelPoint, _pixelData, viewRect);
            }
            
            if (edgePoint) {
                // note: assumes edgePoint is always a solid pixel
                CGRect viewRect = pixelRectForSprite(self.view, 0);
                BMPixelInfo *edgePixelInfo = (BMPixelInfo *)[_pixelData objectAtIndex:indexForPoint(edgePoint.point, viewRect)];
                if (!edgePixelInfo.isSurface) {
                    NSArray *surfacePoints = [self _createSurfaceForEdgePoint:edgePoint];
                    [_edgePoints addObject:surfacePoints];
                }
            }
        }
    }
}

- (CGFloat)_setupData
{
    NSAssert(_pixelData, @"_pixelData is not set!");
    // TODO: - Mark Kim - will probably need to change this for maps that are larger than screen size
    //CGSize viewSize = TEST_IMAGE_SIZE; // TODO: - Mark Kim must change this viewSize
    CGSize viewSize = CGSizeMake(IMAGE_PIXEL_STEP_X, IMAGE_PIXEL_STEP_Y);
    
    uint8 data[4];
    
    CGRect viewRect = pixelRectForSprite(self.view, 0);
    int offsetX = (int)viewRect.origin.x;
    int offsetY = (int)viewRect.origin.y;
    int widthInPixels = (int)viewRect.size.width;
    int heightInPixels = (int)viewRect.size.height;
    
    NSDate *start = [NSDate date];
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:viewSize.width
                                                                     height:viewSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CGFloat time_init_render_texture = fabs([start timeIntervalSinceNow]);
    [renderTexture beginWithClear:1 g:1 b:1 a:0];
    CGFloat time_begin_with_clear = fabs([start timeIntervalSinceNow]) - time_init_render_texture;
    [self.view visit];
    CGFloat time_view_visit = fabs([start timeIntervalSinceNow]) - time_begin_with_clear;
    
    for (int i = offsetY; i < (heightInPixels + offsetY); ++i) {
        for (int j = offsetX; j < (widthInPixels + offsetX); ++j) {
            NSDate *start_read_data = [NSDate date];
            CGPoint pixelPoint = ccp(j, i);
            glReadPixels(pixelPoint.x, pixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
            double time_gl_read_pixels = fabs([start_read_data timeIntervalSinceNow]);
            BMPixelInfo *pixelInfo = [[BMPixelInfo alloc] init];
            pixelInfo.isClear = [self _isPixelClear:data];
            [_pixelData addObject:pixelInfo];
            [pixelInfo release];
            
            double time_add_object_to_array = fabs([start_read_data timeIntervalSinceNow]) - time_gl_read_pixels;
            //debug(@"[1] ### time_gl_read_pixels: %f", time_gl_read_pixels);
            //debug(@"[2] ### time_add_object_to_array: %f", time_add_object_to_array);
        }
    }
    CGFloat time_pixel_data = fabs([start timeIntervalSinceNow]) - time_view_visit;
    
    //debug(@"widthInPixels: %d heightInPixels: %d pixelData count: %d", widthInPixels, heightInPixels, [_pixelData count]);
    [renderTexture end];
    [renderTexture release];
    CGFloat time_end_render_texture = fabs([start timeIntervalSinceNow]) - time_pixel_data;
    //debug(@"[1] ### time_init_render_texture: %f", time_init_render_texture);
    //debug(@"[2] ### time_begin_with_clear: %f", time_begin_with_clear);
    //debug(@"[3] ### time_view_visit: %f", time_view_visit);
    //debug(@"[4] ### time_pixel_data: %f", time_pixel_data);
    //debug(@"[5] ### time_end_render_texture: %f", time_end_render_texture);
    
    // move self.view to final position after setup
    self.view.position = _spriteInfo.finalPosition;
    
    //debug(@"setup duration: %f", fabs([start timeIntervalSinceNow]));
    return fabs([start timeIntervalSinceNow]);
}

- (CGFloat)_reloadData
{
    NSDate *start = [NSDate date];
    
    [self _reloadSurfaces];
    //debug(@"[2] ### surface duration: %f", fabs([start timeIntervalSinceNow]));
    //NSDate *delegate_start = [NSDate date];
    if (_delegate) {
        [_delegate ground:self didReloadData:_edgePoints];
    } else {
        debug(@"WARNING: not using delegate in BMGround!");
    }
    //debug(@"[3] ### didReloadData duration: %f read_pixel_debug_count: %d", fabs([delegate_start timeIntervalSinceNow]), read_pixel_debug_count);
    return fabs([start timeIntervalSinceNow]);
}

- (CGFloat)reload
{
    read_pixel_debug_count = 0;
    CGFloat setupTime = 0.0;
    CGFloat reloadTime = 0.0;
    if ([_pixelData count] == 0) {
        setupTime = [self _setupData];
        //debug(@"[1] ### setup data time: %f", setupTime);
    }
    reloadTime = [self _reloadData];
    return (setupTime + reloadTime);
}

// TODO: - Mark Kim - can optimize this by checking if the damage radius even touches any solid pixels
// if damage radius doesn't touch any solid pixels, then you don't have to reload the ground
- (void)removeGroundWithDamage:(BMDamage *)damage
{
    CCMutableTexture2D *tex = (CCMutableTexture2D *)self.view.texture;
    CGRect texPixelRect = pixelRectForSprite(self.view, 0);
    removePixelsFromTexture(tex, texPixelRect, damage.centerPoint, damage.radius, _pixelData);
}

- (void)logColorForPoint:(CGPoint)touchPoint
{
    CCRenderTexture *renderTexture = [[CCRenderTexture alloc] initWithWidth:self.view.contentSize.width
                                                                     height:self.view.contentSize.height
                                                                pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    uint8 data[4];
    CGPoint pixelPoint = ccpMult(touchPoint, CC_CONTENT_SCALE_FACTOR());
    
    [renderTexture beginWithClear:0 g:0 b:0 a:0];

    [self.view visit];
    ++read_pixel_debug_count;
    glReadPixels((GLint)pixelPoint.x, (GLint)pixelPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    [renderTexture end];
    [renderTexture release];
    
    debug(@"R: %u, G: %u, B: %u, A: %u", data[0], data[1], data[2], data[3]);
}

+ (id)groundWithDelegate:(id<BMGroundDelegate>)delegate
                viewInfo:(BMSpriteInfo *)viewInfo
{
    return [[[self alloc] initWithDelegate:delegate
                                  viewInfo:viewInfo] autorelease];
}

- (id)initWithDelegate:(id<BMGroundDelegate>)delegate viewInfo:(BMSpriteInfo *)viewInfo
{
    if (self = [super init]) {
        self.modelType = kGroundModel;
        self.view = viewInfo.view;
        
        _spriteInfo = [viewInfo retain];
        surface_debug_count = 0;
        read_pixel_debug_count = 0;
        _edgePoints = [[NSMutableArray alloc] init];
        _pixelData = [[NSMutableArray alloc] init];
        _delegate = delegate;        
    }
    return self;
}

@end

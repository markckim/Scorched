//
//  image_functions.h
//  Scorched
//
//  Created by Mark Kim on 4/9/13.
//  Copyright (c) 2013 Mark Kim. All rights reserved.
//

#ifndef Scorched_image_functions_h
#define Scorched_image_functions_h

#import "BMPixelInfo.h"
#import "BMPoint.h"
#import "CCMutableTexture2D.h"
#import "BMSpriteInfo.h"

#import "basic_functions.h"
#import "cocos2d.h"
#import "enum_constants.h"

CG_INLINE BOOL
isPixelOutsideView(CGPoint pixelPoint, CCSprite *view)
{
    // note: assumes use of pixelPoints only
    //NSAssert(view, @"ERROR: view is nil!");
    BOOL isPointOutsideView = NO;
    int pixelPointX = (int)roundf(pixelPoint.x);
    int pixelPointY = (int)roundf(pixelPoint.y);
    int leftX = (int)roundf(((view.position.x - 0.5 * view.contentSize.width) * CC_CONTENT_SCALE_FACTOR()));
    int rightX = (int)roundf(((view.position.x + 0.5 * view.contentSize.width) * CC_CONTENT_SCALE_FACTOR()));
    int botY = (int)roundf(((view.position.y - 0.5 * view.contentSize.height) * CC_CONTENT_SCALE_FACTOR()));
    int topY = (int)roundf(((view.position.y + 0.5 * view.contentSize.height) * CC_CONTENT_SCALE_FACTOR()));
    
    if (pixelPointX < leftX || pixelPointX >= rightX ||
        pixelPointY < botY || pixelPointY >= topY) {
        isPointOutsideView = YES;
    }
    return isPointOutsideView;
}

CG_INLINE void
removePixelsFromTexture(CCTexture2DMutable *tex,
                        const CGRect texPixelRect,
                        const CGPoint centerPixelPoint,
                        const CGFloat pixelRadius,
                        NSMutableArray *pixelData)
{
    CGRect damagePixelRect = rectBoundingCircle(centerPixelPoint, pixelRadius);
    CGRect intersectingPixelRect = rectIntersectingRects(damagePixelRect, texPixelRect);
    intersectingPixelRect = rectForRect(intersectingPixelRect, 0);
    
    int leftPixel = (int)roundf(intersectingPixelRect.origin.x);
    int rightPixel = (int)roundf(intersectingPixelRect.origin.x) + (int)roundf(intersectingPixelRect.size.width);
    int botPixel = (int)roundf(intersectingPixelRect.origin.y);
    int topPixel = (int)roundf(intersectingPixelRect.origin.y) + (int)roundf(intersectingPixelRect.size.height);
    //debug(@"texPixelRect: %@", stringForRect(texPixelRect));
    //debug(@"intersectionPixelRect: %@", stringForRect(intersectingPixelRect));
    //debug(@"leftPixel: %d, rightPixel: %d, botPixel: %d, topPixel: %d", leftPixel, rightPixel, botPixel, topPixel);
    
    // if pixel is inside circle, make it clear
    for (int yPixel = botPixel; yPixel < topPixel; ++yPixel) {
        for (int xPixel = leftPixel; xPixel < rightPixel; ++xPixel) {
            CGPoint testPixelPoint = ccp(xPixel, yPixel);
            CGFloat distanceX = testPixelPoint.x - centerPixelPoint.x;
            CGFloat distanceY = testPixelPoint.y - centerPixelPoint.y;
            CGFloat distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
            CGFloat radiusSquared = pixelRadius * pixelRadius;
            if (distanceSquared < radiusSquared) {
                // note: i don't understand this very well, and why i need the -1.0
                // TODO: - Mark Kim - understand this conversion
                CGPoint renderPixelPoint = ccpSub(testPixelPoint, texPixelRect.origin);
                renderPixelPoint = ccp(renderPixelPoint.x, texPixelRect.size.height - renderPixelPoint.y - 1.0);
                [tex setPixelAt:renderPixelPoint rgba:ccc4(0, 0, 0, 0)];
                
                int index = indexForPoint(testPixelPoint, texPixelRect);
                if (index >=0 && index < [pixelData count]) {
                    BMPixelInfo *pixelInfo = (BMPixelInfo *)[pixelData objectAtIndex:index];
                    pixelInfo.isClear = YES;
                } else {
                    debug(@"WARNING: attempting to access index %d in pixelData that is out of range!", index);
                }
            }
        }
    }
    [tex apply];
}

CG_INLINE BMPoint*
solidPointBetweenPixelPoints(const CGPoint pixelPoint1, const CGPoint pixelPoint2, const NSArray *pixelData, const CGRect viewRect)
{
    // assumptions:
    // * one of the pixel points is clear and the other is solid
    // * the pixel points are parallel along the x-axis
    // * pixelPoint1 has a lower x-coordinate value than pixelPoint2
    
    BMPixelInfo *pixelInfo = (BMPixelInfo *)[pixelData objectAtIndex:indexForPoint(pixelPoint2, viewRect)];
    BOOL isPixel2Clear = pixelInfo.isClear;
    
    // data validation
    //NSAssert(isPixel1Clear != isPixel2Clear, @"pixel1 and pixel2 alpha cannot be the same!");
    //NSAssert(pixelPoint1.y == pixelPoint2.y, @"point1 and point2 cannot be at different y values!");
    //NSAssert(pixelPoint1.x < pixelPoint2.x, @"point1 must have a lower x value than point2!");
    
    CGPoint pixelPoint = pixelPoint1;
    CGPoint stepPixelVector = ccp(1.0, 0.0);
    CGPoint nextPixelPoint;
    while (pixelPoint.x < pixelPoint2.x) {
        nextPixelPoint = ccpAdd(pixelPoint, stepPixelVector);
        // check if boundary reached
        BMPixelInfo *testPixelInfo = (BMPixelInfo *)[pixelData objectAtIndex:indexForPoint(nextPixelPoint, viewRect)];
        if (testPixelInfo.isClear == isPixel2Clear) {
            // get solid pixel point
            if (!testPixelInfo.isClear) {
                //debug(@"[1] found boundary at pixelPoint: %f, %f", nextPixelPoint.x, nextPixelPoint.y);
                return [BMPoint pointWithPixelPoint:nextPixelPoint fromDirection:kWest];
            } else {
                //debug(@"[2] found boundary at pixelPoint: %f, %f", pixelPoint.x, pixelPoint.y);
                return [BMPoint pointWithPixelPoint:pixelPoint fromDirection:kEast];
            }
        }
        pixelPoint = nextPixelPoint;
    }
    debug(@"ERROR: did not find boundary!");
    return nil;
}

CG_INLINE NSArray*
positionedSpritesFromImage(UIImage *im, int widthPixelStride, int heightPixelStride)
{
    int surface_debug_count = 0;
    int imageWidth = [im size].width * im.scale;
    int imageHeight = [im size].height * im.scale;
    NSMutableArray *sprites = [NSMutableArray array];
    
    // tracking stride
    for (int i=0; i<imageHeight; i+=heightPixelStride) {
        int heightStrideLeft = imageHeight - i;
        int adjustedHeightStride = MIN(heightPixelStride, heightStrideLeft);
        
        for (int j=0; j<imageWidth; j+=widthPixelStride) {
            int widthStrideLeft = imageWidth - j;
            int adjustedWidthStride = MIN(widthPixelStride, widthStrideLeft);
            
            CGRect imageRect = CGRectMake(j , i, adjustedWidthStride, adjustedHeightStride);
            ++surface_debug_count;
            
            UIGraphicsBeginImageContext(imageRect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -imageRect.size.height);
            CGContextTranslateCTM(context, -imageRect.origin.x, -imageRect.origin.y);
            CGContextDrawImage(context, CGRectMake(0.0, 0.0, imageWidth, imageHeight), [im CGImage]);
            
            // TODO: - Mark Kim - need to be able to get proper images for all device types
            CGImageRef imageRef = CGBitmapContextCreateImage(context);
            CCTexture2DMutable *tex = [[CCTexture2DMutable alloc] initWithCGImage:imageRef
                                                                   resolutionType:kCCResolutioniPhoneRetinaDisplay];
            CGImageRelease(imageRef);
            
            CCSprite *sprite = [CCSprite spriteWithTexture:tex];
            CGPoint finalPosition = ccp(((float)j + 0.5 * (float)adjustedWidthStride) / CC_CONTENT_SCALE_FACTOR(),
                                        ((float)i + 0.5 * (float)adjustedHeightStride) / CC_CONTENT_SCALE_FACTOR());
            // TODO: - Mark Kim - take out this positioning after testing
            //sprite.position = finalPosition;
            
            BMSpriteInfo *spriteInfo = [[BMSpriteInfo alloc] initWithView:sprite finalPosition:finalPosition];
            
            [sprites addObject:spriteInfo];
            [spriteInfo release];
            [tex release];
        }
    }
    return sprites;
}

#endif

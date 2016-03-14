//
//  AFilter.m
//  ios-filters
//
//  Created by Bert Heinzelman on 8/9/15.
//  Copyright (c) 2015 heinzelmanb. All rights reserved.
//

#import "AFilter.h"

@interface AFilter ()

#if !(TARGET_OS_IPHONE)
-(CGImageRef) CGImageCreateWithNSImage:(Image *)image;
#endif

@end

@implementation AFilter

-(Image*)filter:(Image *)in {
    return nil;
}

#pragma mark private methods
-(Byte*)getBytes:(Image*)in width:(NSUInteger*) width height:(NSUInteger*)height {
#if TARGET_OS_IPHONE
    CGImageRef imageRef = [in CGImage];
#else
    CGImageRef imageRef = [self CGImageCreateWithNSImage: in];
#endif
    *width = CGImageGetWidth(imageRef);
    
    *height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    Byte* raw = (Byte*)calloc((*height)*(*width)*4, sizeof(Byte));
    
    NSUInteger channels = 4;
    
    NSUInteger bytesPerRow = channels * (*width);
    
    NSUInteger bitsPerChannel = 8;
    
    CGContextRef context = CGBitmapContextCreate(raw, *width, *height, bitsPerChannel, bytesPerRow, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, *width, *height), imageRef);

    CGContextRelease(context);
    
    return raw;

}


-(Image*)packageBytes:(Byte *)rawData width:(NSUInteger)width height:(NSUInteger)height channels:(NSUInteger)channels {
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext=CGBitmapContextCreate(rawData, width, height, 8, channels * width, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CFRelease(colorSpace);
    
    
    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
#if TARGET_OS_IPHONE
    UIImage * newimage = [UIImage imageWithCGImage:cgImage];
#else
    NSImage* newimage = [[NSImage alloc] initWithCGImage:cgImage size:(NSSize) {width, height}];
#endif
    CGImageRelease(cgImage);
    
    return newimage;
}

#if !(TARGET_OS_IPHONE)
-(CGImageRef) CGImageCreateWithNSImage:(NSImage *)image {
    NSSize imageSize = [image size];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [image drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return cgImage;
}
#endif
@end

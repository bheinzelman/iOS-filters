//
//  AFilter.h
//  ios-filters
//
//  Created by Bert Heinzelman on 8/9/15.
//  Copyright (c) 2015 heinzelmanb. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIImage Image;
#else
#import <Cocoa/Cocoa.h>
typedef NSImage Image;
#endif

#import <CoreGraphics/CoreGraphics.h>

typedef unsigned char Byte;
typedef unsigned long ulong;

@interface AFilter : NSObject

-(Image*)filter:(Image*)in;

-(Byte*)getBytes:(Image*)in width:(NSUInteger*) width height:(NSUInteger*)height;

-(Image*)packageBytes:(Byte*)rawData width:(NSUInteger)width height:(NSUInteger)height channels:(NSUInteger)channels;

@end

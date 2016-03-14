//
//  Sharpen.m
//  ios-filters
//
//  Created by Bert Heinzelman on 1/19/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import "Sharpen.h"
#import "KernelFilter.h"

@implementation Sharpen

-(Image*)filter:(Image *)in {
    
    double kernel[] =
    {
      -1,  -1,  -1,  -1,  -1,
      -1,   2,   2,   2,  -1,
      -1,   2,   8,   1,  -1,
      -1,   2,   2,   2,  -1,
      -1,  -1,  -1,  -1,  -1
    };
    
    NSUInteger* width = (NSUInteger*)malloc(sizeof(NSUInteger));
    
    NSUInteger* height = (NSUInteger*)malloc(sizeof(NSUInteger));
    
    Byte* rawData = [self getBytes:in width:width height:height];

    KernelFilter* kf = [[KernelFilter alloc] init:rawData height:*height width:*width
                                           kernel:kernel ksize:5 factor:1.0/8.0 bias:0];
    
    [kf applyKernel];
    
    Image* im = [self packageBytes:rawData width:*width height:*height channels:4];
    
    free(rawData);
    free(width);
    free(height);
    
    return im;
    
}

@end

//
//  KernelFIlter.m
//  ios-filters
//
//  Created by Bert Heinzelman on 1/19/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import "KernelFilter.h"

@interface KernelFilter ()

-(Byte*)getChannel:(int)chan;

-(void)putChannelBack:(int)chan channel:(Byte*)channel;

-(void)applyKernel:(Byte*)channel;

@end

@implementation KernelFilter

#pragma mark constructor
-(id)init:(Byte*)data height:(ulong)height width:(ulong)width kernel:(double*)kernel ksize:(int)ksize factor:(double)factor bias:(double)bias{
    
    if (self = [super init]) {
        self.kernel = kernel;
        
        self.data = data;
        
        self.height = height;
        
        self.width = width;
        
        self.ksize = ksize;
        
        self.factor = factor;
        
        self.bias = bias;
        
        return  self;
    }
   
    return nil;
}

#pragma mark setup
-(Byte*)getChannel:(int)chan {
    Byte* channel = malloc(self.height * self.width);
    unsigned long chanI = 0;
    
    for (unsigned long i = chan; i < self.height * self.width * 4; i+=4) {
        channel[chanI] = self.data[i];
        chanI++;
    }
    
    return channel;
}

-(void)putChannelBack:(int)chan channel:(Byte*)channel {
    unsigned long chanI = 0;
    
    for (unsigned long i = chan; i < self.height * self.width * 4; i+=4) {
        self.data[i] = channel[chanI];
        chanI++;
    }
}


#pragma mark filter
/*
 * breaks up the job for each channel and places it into a run queue
 * applies the filter, then puts channel back into the data
 */
-(void)applyKernel {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^(void) {
      //red
        Byte* red = [self getChannel:0];
       
        [self applyKernel:red];
        
        [self putChannelBack:0 channel:red];
        
        free(red);
    });
    dispatch_group_async(group, queue, ^(void) {
       //green
        Byte* green = [self getChannel:1];
        
        [self applyKernel:green];
        
        [self putChannelBack:1 channel:green];
        
        free(green);
    });
    dispatch_group_async(group, queue, ^(void) {
       //blue
        Byte* blue = [self getChannel:2 ];
       
        [self applyKernel:blue];
        
        [self putChannelBack:2 channel:blue];
        
        free(blue);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

/*
 * code that actually applies the kernel to each channel
 */
-(void)applyKernel:(Byte *)channel {
    const int KHEIGHT = self.ksize;
    const int KWIDTH = self.ksize;
    
    for (ulong y = 0; y < _height; y++) {
        for (ulong x = 0; x < _width; x++) {
            double val = 0;
            
            for (int ky = 0; ky < KHEIGHT; ky++) {
                for (int kx = 0; kx < KWIDTH; kx++) {
                    long imageX = (x - KWIDTH / 2 + kx + _width) % _width;
                    
                    long imageY = (y - KHEIGHT / 2 + ky + _height) % _height;
                    
                    ulong pixelPos = imageY * _width + imageX;
                    
                    val += channel[pixelPos] * self.kernel[ky * KWIDTH + kx];
                }
            }
            val *= self.factor;
            val += self.bias;
            
            if (val > 255) val = 255;
            if (val < 0) val = 0;
            
            channel[y * _width + x] = val;
            
        }
    }
}

@end

//
//  KernelFIlter.h
//  ios-filters
//
//  Created by Bert Heinzelman on 1/19/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import "AFilter.h"

@interface KernelFilter : NSObject

-(id)init:(Byte*)data height:(ulong)height width:(ulong)width kernel:(double*)kernel ksize:(int)ksize factor:(double)factor bias:(double)bias;

-(void)applyKernel;

@property (nonatomic) double* kernel;

@property (nonatomic) ulong height;

@property (nonatomic) ulong width;

@property (nonatomic) Byte* data;

@property (nonatomic) int ksize;

@property (nonatomic) double factor;

@property (nonatomic) double bias;

@end

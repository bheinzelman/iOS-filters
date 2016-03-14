//
//  Negative.m
//  ios-filters
//
//  Created by Bert Heinzelman on 1/18/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import "Negative.h"

@implementation Negative

-(Image*)filter:(Image *)in {
    NSUInteger* width = (NSUInteger*)malloc(sizeof(NSUInteger));
    
    NSUInteger* height = (NSUInteger*)malloc(sizeof(NSUInteger));
    
    Byte* rawData = [self getBytes:in width:width height:height];
    
    for (NSUInteger i = 0; i < 4 * (*height) * (*width); i += 4)
    {
        rawData[i] = 255 - rawData[i];
        rawData[i+1] = 255 - rawData[i+1];
        rawData[i+2] = 255 - rawData[i+2];
        
    }
    
    Image* im = [self packageBytes:rawData width:*width height:*height channels:4];
    
    //free(rawData);
    free(width);
    free(height);
    
    return im;
}

@end

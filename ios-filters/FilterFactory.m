//
//  FilterFactory.m
//  ios-filters
//
//  Created by Bert Heinzelman on 1/18/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import "FilterFactory.h"
#import "Negative.h"
#import "Sharpen.h"
#import "Normal.h"
#import "Edge.h"


@implementation FilterFactory

+(AFilter*) getFilter:(enum FILTER)type {
    switch (type) {
        case NEGATIVE:
            return [[Negative alloc] init];
        case SHARPEN:
            return [[Sharpen alloc] init];
        case NORMAL:
            return [[Normal alloc] init];
        case EDGE:
            return [[Edge alloc] init];
        default:
            return nil;
    }
}

@end

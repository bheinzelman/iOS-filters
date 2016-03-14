//
//  FilterFactory.h
//  ios-filters
//
//  Created by Bert Heinzelman on 1/18/16.
//  Copyright © 2016 heinzelmanb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFilter.h"

enum FILTER {
    NORMAL = 0,
    NEGATIVE = 1,
    SHARPEN = 2,
    EDGE = 3,
};
@interface FilterFactory : NSObject

+(AFilter*)getFilter:(enum FILTER) type;

@end

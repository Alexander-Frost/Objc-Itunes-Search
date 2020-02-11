//
//  SFOMovie.m
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "SFOMovie.h"

@implementation SFOMovie

- (instancetype)initWithName:(NSString *)name
                        year:(int)year
                       about:(NSString *)about {
    self = [super init];
    if (self) {
        _name = [name copy];
        _year = year;
        _about = [about copy];
    }
    return self;
}

@end

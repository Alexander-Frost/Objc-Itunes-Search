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
                  collection:(NSString *)collection
                    imageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        _name = [name copy];
        _collection = [collection copy];
        _imageUrl = [imageUrl copy];
    }
    return self;
}

@end

//
//  SFOMovie+NSJSONSerialization.m
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "SFOMovie.h"
#import "SFOMovie+NSJSONSerialization.h"

@implementation SFOMovie (NSJSONSerialization)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    NSString *name = dictionary[@"trackName"];
    NSString *collection = dictionary[@"collectionName"];
    NSString *imageUrl = dictionary[@"artworkUrl100"];
    
    return [self initWithName:name collection:collection imageUrl:imageUrl];
}

- (NSDictionary *)toDictionary {
    NSDictionary *dictionary = @{
        @"trackName" : self.name,
        @"collectionName" : self.collection,
        @"artworkUrl100" : self.imageUrl
    };
    return dictionary;
}

@end

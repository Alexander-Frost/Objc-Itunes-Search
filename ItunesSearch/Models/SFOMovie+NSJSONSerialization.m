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

//    NSLog(@"%@", dictionary[@"intFormedYear"]);
//    NSString *yearNum = dictionary[@"intFormedYear"];//yearInt;
//    if ([yearNum isKindOfClass:[NSString class]] || [yearNum isKindOfClass:[NSNumber class]]) {
//        NSLog(@"%@", yearNum);
//        int year = [yearNum intValue];
//        return [self initWithName: name year:year about:about];
//    } else {
//        int year = 0;
//        return [self initWithName: name year:year about:about];
//    }
}

- (NSDictionary *)toDictionary {
//    NSNumber *yearNum = [NSNumber numberWithInt:self.year];
    NSDictionary *dictionary = @{
        @"trackName" : self.name, //strArtist
        @"collectionName" : self.collection, //intFormedYear
        @"artworkUrl100" : self.imageUrl //strBiographyEN
    };
    return dictionary;
}

@end

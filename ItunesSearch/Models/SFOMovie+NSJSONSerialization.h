//
//  SFOMovie+NSJSONSerialization.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class SFOMovie;

@interface SFOMovie (NSJSONSerialization)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END




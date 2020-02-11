//
//  SFOMovie.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFOMovie : NSObject

@property (nonatomic, copy)NSString *collection;
@property (nonatomic, copy)NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name
                  collection:(NSString *)collection
                    imageUrl:(NSString *)imageUrl;
@end

NS_ASSUME_NONNULL_END

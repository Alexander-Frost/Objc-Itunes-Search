//
//  SFOMovieController.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFOMovie;

@interface SFOMovieController : NSObject

@property (readonly, nonatomic) NSArray *savedMovies;
@property (readonly, nonatomic) SFOMovie *currentMovie;

- (void)loadFromPersistentStore;
- (void)saveMovie:(SFOMovie *)artist;
- (void)removeMovie:(SFOMovie *)artist;
- (void)searchForMovieWithName:(NSString *)name completion:(void (^)(SFOMovie *artist, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END

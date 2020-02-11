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
@property (strong, nonatomic) NSMutableArray<SFOMovie*> *results;

- (void)loadFromPersistentStore;
- (void)saveMovie:(SFOMovie *)movie;
- (void)removeMovie:(SFOMovie *)movie;
- (void)searchiTunesWithTerm:(NSString *)searchTerm completion:(void (^)(SFOMovie *movie, NSError *error))completion;
- (void)parseSearchResults:(NSData *)data response:(NSURLResponse *)response;

@end

NS_ASSUME_NONNULL_END

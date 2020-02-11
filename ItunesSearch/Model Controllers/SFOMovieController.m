//
//  SFOMovieController.m
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "SFOMovieController.h"
#import "SFOMovie.h"
#import "SFOMovie+NSJSONSerialization.h"

@interface SFOMovieController() {}

@property (nonatomic) NSMutableArray *internalSavedMovies;

@end

@implementation SFOMovieController

// MARK: - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalSavedMovies = [[NSMutableArray alloc] init];
    }
    return self;
}

// MARK: - Properties

- (NSArray *)savedMovies {
    return [self.internalSavedMovies copy];
}

static NSString * const baseURLString = @"https://itunes.apple.com/search?term=%@";

// MARK: - Operations

- (void)saveMovie:(SFOMovie *)movie {
    NSLog(@"saveArtist");
    [self.internalSavedMovies addObject:movie];
    [self saveToPersistentStore];
}

- (void)removeMovie:(SFOMovie *)movie {
    [self.internalSavedMovies removeObject:movie];
    [self saveToPersistentStore];
}

- (NSURL *)persistentFileURL {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *fileName = @"movies.json";
    return [documentDirectory URLByAppendingPathComponent:fileName];
}

- (void)saveToPersistentStore {
    NSError *saveError = nil;
    NSURL *url = [self persistentFileURL];
    NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
    
    for (SFOMovie *movie in self.internalSavedMovies) {
        NSDictionary *movieDict = [movie toDictionary];
        [moviesArray addObject:movieDict];
    }
    NSDictionary *moviesDictionary = @{
        @"movies" : moviesArray
    };
    bool successfulSave = [moviesDictionary writeToURL:url error:nil];
    if (successfulSave) {
        NSLog(@"saved");
        return;
    } else {
        NSLog(@"Error saving movies: %@", saveError);
    }
}

- (void)loadFromPersistentStore {
    NSURL *url = [self persistentFileURL];
    
    NSDictionary *moviesDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
    if (![moviesDictionary[@"movies"]  isEqual: @""]) {
        NSArray *movieDictionaries = moviesDictionary[@"movies"];
        for (NSDictionary *movieDictionary in movieDictionaries) {
            SFOMovie *movie = [[SFOMovie alloc] initWithDictionary:movieDictionary];
            [self.internalSavedMovies addObject:movie];
        }
    }
}

// MARK: - Search

- (void)searchiTunesWithTerm:(NSString *)searchTerm completion:(void (^)(SFOMovie *movie, NSError *error))completion {
    NSString *stringURL = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", searchTerm];
    NSLog(@"making request: %@", stringURL);
    NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
//            [self handleError:error];
            completion(nil, error);
        } else {
            [self parseSearchResults:data response:response];
            completion(nil, nil);
        }
    }];
    [task resume];
}

- (void)parseSearchResults:(NSData *)data response:(NSURLResponse *)response {
    NSError *error = nil;
    
    if (error) {
//        [self handleError:error];
    } else {
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSLog(@"%@", result);
        NSMutableArray <SFOMovie*> *allMovies = [NSMutableArray new];
        NSArray * results = result[@"results"]; //artistName
        for (NSDictionary * movieDict in results) {
            NSLog(@"%@", movieDict);
            NSString * name = movieDict[@"artistName"];
            NSString * collectionName = movieDict[@"collectionName"];
            NSString * avatarUrl = movieDict[@"artworkUrl100"];

            SFOMovie * myMovie = [[SFOMovie alloc] initWithName:name collection:collectionName imageUrl:avatarUrl];
            // Append movie
            [allMovies addObject:myMovie];
        }
        self.results = allMovies; //((NSDictionary *)result)[@"results"];
    }
}

@end

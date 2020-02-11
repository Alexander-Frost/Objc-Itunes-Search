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

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalSavedMovies = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)savedMovies {
    return [self.internalSavedMovies copy];
}

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
    NSString *fileName = @"artists.json";
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
        @"artists" : moviesArray
    };
    bool successfulSave = [moviesDictionary writeToURL:url error:nil];
    if (successfulSave) {
        NSLog(@"saved");
        return;
    } else {
        NSLog(@"Error saving artists: %@", saveError);
    }
}

- (void)loadFromPersistentStore {
    NSURL *url = [self persistentFileURL];
    
    NSDictionary *moviesDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
    if (![moviesDictionary[@"artists"]  isEqual: @""]) {
        NSArray *movieDictionaries = moviesDictionary[@"artists"];
        for (NSDictionary *movieDictionary in movieDictionaries) {
            SFOMovie *movie = [[SFOMovie alloc] initWithDictionary:movieDictionary];
            [self.internalSavedMovies addObject:movie];
        }
    }
}


static NSString * const baseURLString = @"https://www.theaudiodb.com/api/v1/json/1/search.php";











- (void)searchForMovieWithName:(NSString *)name completion:(void (^)(SFOMovie *movie, NSError *error))completion {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    
    NSURLQueryItem *searchItem = [NSURLQueryItem queryItemWithName:@"s" value:name];
    [components setQueryItems:@[searchItem]];
    NSURL *url = [components URL];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        NSError *jsonError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a Dictionary as expected");
            completion(nil, [[NSError alloc] init]);
            return;
        }
        
        if (dictionary[@"artists"] != [NSNull null]) {
            NSArray *movieDictionaries = dictionary[@"artists"];
            NSDictionary *movieDictionary = movieDictionaries.firstObject;
            SFOMovie *movie = [[SFOMovie alloc] initWithDictionary:movieDictionary];
            
            completion(movie, nil);
        }
    }] resume];
}



// MARK: - Network Calls

- (void)searchiTunesWithTerm:(NSString *)searchTerm {
    NSString *stringURL = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", searchTerm];
    NSLog(@"making request: %@", stringURL);
    NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            [self handleError:error];
        } else {
            [self parseSearchResults:data response:response];
        }
    }];
    [task resume];
}

- (void)parseSearchResults:(NSData *)data response:(NSURLResponse *)response {
    NSLog(@"%@", response.MIMEType);
    NSLog(@"%@", response.textEncodingName);
    
    NSError *error = nil;
    
    if (error) {
        [self handleError:error];
    } else {
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        self.results = ((NSDictionary *)result)[@"results"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSearchCompleteNotification object:nil];
        NSLog(@"%@", self.results);
    }
}

@end

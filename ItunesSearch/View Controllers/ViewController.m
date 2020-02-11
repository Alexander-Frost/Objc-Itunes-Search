//
//  ViewController.m
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "SavedMoviesTableViewController.h"
#import "SFOMovie.h"
#import "SFOMovieController.h"

static NSString *resultCell = @"resultCell";
static NSString *kSearchCompleteNotification = @"searchComplete";

@interface ViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *results;

@end

@implementation ViewController

// MARK: - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self registerForNotifications];
}

- (void)dealloc {
    [self unregisterForNotification];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SavedMoviesSegue"]) {
        SavedMoviesTableViewController *detailVC = segue.destinationViewController;
        detailVC.movieController = self.movieController;
    }
    
    if ([segue.identifier isEqualToString:@"MovieDetailSegue"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.movieController = self.movieController;

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SFOMovie *movie = self.movieController.savedMovies[indexPath.row];
        detailVC.movie = movie;
    }
}

// MARK: - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchiTunesWithTerm:searchBar.text];
    
    // below
    NSString *searchTerm = searchBar.text;
    
    [self.movieController searchForMovieWithName:searchTerm completion:^(SFOMovie *movie, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Movie: %@, Error: %@", movie.name, error);
            self.movie = movie;
        });
    }];
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

- (void)handleError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:[NSString stringWithFormat: @"Your search failed. - %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

// MARK: - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultCell];
    
    NSDictionary *resultItem = self.results[indexPath.row];
    
    cell.textLabel.text = resultItem[@"trackName"]; //+ " HERE: " + resultItem["collectionName"];
    cell.detailTextLabel.text = resultItem[@"collectionName"]; //resultItem[@"artistName"]; //artworkUrl100
    
    
    return cell;
}

// MARK: - Notifcations

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyTableView) name:kSearchCompleteNotification object:nil];
}

- (void)unregisterForNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadMyTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end


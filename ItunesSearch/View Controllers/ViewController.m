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

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.movieController = [[SFOMovieController alloc] init];
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
        SFOMovie *movie = self.movieController.results[indexPath.row];
        detailVC.movie = movie;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    
    [self.movieController searchiTunesWithTerm:searchTerm completion:^(SFOMovie * _Nonnull movie, NSError * _Nonnull error) {
        NSLog(@"Movie: %@, HERE Error: %@", movie.name, error);
        [self reloadMyTableView];
    }];
}

- (void)handleError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:[NSString stringWithFormat: @"Your search failed. - %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieController.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultCell];
    
    SFOMovie *resultItem = self.movieController.results[indexPath.row]; //self.results[indexPath.row];
    
    cell.textLabel.text = resultItem.name; //resultItem[@"trackName"];
    cell.detailTextLabel.text = resultItem.imageUrl; //resultItem[@"collectionName"]; //artworkUrl100
    
    return cell;
}

#pragma mark - Notifcations

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


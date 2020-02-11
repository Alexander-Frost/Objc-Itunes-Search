//
//  SavedMoviesTableViewController.m
//  ItunesSearch
//
//  Created by Alex on 2/11/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "SavedMoviesTableViewController.h"
#import "SFOMovieController.h"
#import "SFOMovie.h"

@interface SavedMoviesTableViewController ()

@end

@implementation SavedMoviesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieController.savedMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    SFOMovie *movie = self.movieController.savedMovies[indexPath.row];
    cell.textLabel.text = movie.name;
    cell.detailTextLabel.text = movie.imageUrl;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SFOMovie *movie = self.movieController.savedMovies[indexPath.row];
        [self.movieController removeMovie:movie];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

@end

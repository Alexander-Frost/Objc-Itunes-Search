//
//  DetailViewController.m
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import "DetailViewController.h"
#import "SFOMovie.h"
#import "SFOMovieController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

// MARK: - Actions

- (IBAction)saveBtnPressed:(UIBarButtonItem *)sender {
    if (self.movie) {
        NSLog(@"saveTapped");
        [self.movieController saveMovie:self.movie];
        [self.navigationController popViewControllerAnimated:true];
    }
}

// MARK: - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateViews];
}

// MARK: - Setup UI

- (void)updateViews {
    __block NSString *name = @"";
    __block NSString *yearFormed = @"";
    __block NSString *bio = @"";

    if (self.movie) {
        name = self.movie.name;
        bio = self.movie.about;
        self.navigationItem.title = name;
    }

    self.titleLbl.text = name;
    self.directorLbl.text = bio;
//    self.miniImageView.image = bio;
}


@end

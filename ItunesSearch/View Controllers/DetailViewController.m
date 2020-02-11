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
    __block NSString *collection = @"";

    if (self.movie) {
        name = self.movie.name;
        collection = self.movie.collection;
        self.navigationItem.title = name;
    }

    self.titleLbl.text = name;
    self.directorLbl.text = collection;
    
    [self loadImage];
}

- (void)loadImage {
    NSString *strImgURLAsString = self.movie.imageUrl; // @"imageURL";
    [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            // pass the img to your imageview
            self.miniImageView.image = img;
            self.miniImageView.layer.cornerRadius = 8.0;
            self.miniImageView.layer.masksToBounds = true;
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
}


@end

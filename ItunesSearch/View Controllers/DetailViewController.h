//
//  DetailViewController.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFOMovie;
@class SFOMovieController;

@interface DetailViewController : UIViewController

// MARK: - Properties

@property SFOMovie* movie;
@property SFOMovieController *movieController;

// MARK: - Outlets

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *directorLbl;
@property (weak, nonatomic) IBOutlet UIImageView *miniImageView;

- (IBAction)saveBtnPressed:(UIBarButtonItem *)sender;

@end

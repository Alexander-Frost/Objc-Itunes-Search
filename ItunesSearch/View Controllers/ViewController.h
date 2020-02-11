//
//  ViewController.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFOMovieController;
@class SFOMovie;

@interface ViewController : UITableViewController

@property SFOMovieController *movieController;
@property SFOMovie *movie;

@end


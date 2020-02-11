//
//  SFOMovie.h
//  ItunesSearch
//
//  Created by Alex on 2/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFOMovie : NSObject

//@property (nonatomic, copy) NSString *name;
@property (nonatomic) int year;
@property (nonatomic, copy)NSString *about;
@property (nullable, nonatomic, copy) NSString *name;


- (instancetype)initWithName:(NSString *)name
                        year:(int)year
                       about:(NSString *)about;

@end

NS_ASSUME_NONNULL_END

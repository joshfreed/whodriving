//
//  TripResultsViewController.h
//  whodriving
//
//  Created by Josh Freed on 10/14/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewLayout;

@interface TripResultsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSArray *drivers;

@end

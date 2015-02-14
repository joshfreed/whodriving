//
//  ResultsViewController.h
//  Who's Driving?!
//
//  Created by Josh Freed on 1/15/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripSpecification.h"

@interface ResultsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property TripSpecification *tripSpec;
@end

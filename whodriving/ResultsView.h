//
//  ResultsView.h
//  Who's Driving?!
//
//  Created by Josh Freed on 12/13/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripSpecification.h"

@protocol ResultsViewDelegate;

@interface ResultsView : UIView
@property (nonatomic, weak) id<ResultsViewDelegate> delegate;
@property TripSpecification *tripSpec;
-(void)viewWillAppear;
@end

@protocol ResultsViewDelegate <NSObject>

- (void)done;

@end

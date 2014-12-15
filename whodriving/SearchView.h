//
//  SearchView.h
//  Who's Driving?!
//
//  Created by Josh Freed on 12/3/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate;

@interface SearchView : UIView

@property (nonatomic, weak) id<SearchViewDelegate> delegate;
@property NSArray *drivers;

-(void)viewWillAppear;

@end

@protocol SearchViewDelegate <NSObject>

- (void)findDrivers:(NSNumber*)personCount;

@end

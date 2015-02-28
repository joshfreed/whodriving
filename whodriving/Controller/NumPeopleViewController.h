//
//  NumPeopleViewController.h
//  Who's Driving?!
//
//  Created by Josh Freed on 2/27/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeView.h"

@interface NumPeopleViewController : UIViewController<WelcomeViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

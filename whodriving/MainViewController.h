//
//  ViewController.h
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WelcomeView.h"

@interface MainViewController : UIViewController <WelcomeViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end


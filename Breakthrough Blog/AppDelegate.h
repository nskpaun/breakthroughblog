//
//  AppDelegate.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    FMDatabase *_database;
}

-(FMDatabase*)getDatabase;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HomeViewController *homeVC;
//@property (strong, nonatomic) UIViewController *viewController;

@end

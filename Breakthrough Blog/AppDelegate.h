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
#import "GAI.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    FMDatabase *_database;
}

extern NSString *const GAID;

//Categories
extern NSString *const HOME_CAT;
extern NSString *const DRILL_CAT; //+Category
extern NSString *const READ_CAT;
extern NSString *const ABOUT_CAT;

//Actions
extern NSString *const NOTE_PRESSED_ACT;
extern NSString *const BACK_PRESSED_ACT;

extern NSString *const CAT_PRESSED_ACT;
extern NSString *const ABOUT_PRESSED_ACT;
extern NSString *const RATING_ACT;
extern NSString *const FEEDBACK_SENT_ACT;

extern NSString *const NOTES_EMPTY_SCREEN_ACT;
extern NSString *const NOTE_SELECTED_ACT;

//extern NSString *const LATER_PRESSED_ACT;
//extern NSString *const SHOW_LOVE_PRESSED_ACT;
//extern NSString *const FEEDBACK_PRESSED_ACT;


extern NSString *const ARTICLE_PRESSED_ACT; //Label shows title and new/not new
extern NSString *const LOAD_MORE_ACT;
extern NSString *const LOAD_MORE_FAILURE_ACT;
extern NSString *const LOAD_MORE_SUCCESS_ACT;
extern NSString *const NAV_PRESSED_ACT;
extern NSString *const NAV_DISMISSED_ACT;
extern NSString *const NAV_SELECTION_ACT;

extern NSString *const SHARE_ACT;
extern NSString *const NOTE_SAVED_ACT;




-(FMDatabase*)getDatabase;
-(void) saveImage:(UIImage*)image withName:(NSString*)fname;
-(UIImage*) loadImage:(NSString*)fname;
-(void)deleteImage:(NSString*)fname;


@property (strong, nonatomic) id<GAITracker> tracker;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HomeViewController *homeVC;
//@property (strong, nonatomic) UIViewController *viewController;

@end

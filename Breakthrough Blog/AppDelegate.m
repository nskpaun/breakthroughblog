//
//  AppDelegate.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiHelper.h"
#import "HomeViewController.h"
#import "GAI.h"

@implementation AppDelegate

@synthesize tracker;

NSString *const GAID  = @"UA-42798880-1";
NSString *openedCount = @"openedCount";

NSString *const HOME_CAT = @"HOME_CAT;";
NSString *const DRILL_CAT = @"DRILL_CAT;";
NSString *const READ_CAT = @"READ_CAT;";
NSString *const ABOUT_CAT = @"ABOUT_CAT;";
NSString *const NOTE_PRESSED_ACT = @"NOTE_PRESSED_ACT;";
NSString *const BACK_PRESSED_ACT = @"BACK_PRESSED_ACT;";
NSString *const CAT_PRESSED_ACT = @"CAT_PRESSED_ACT;";
NSString *const ABOUT_PRESSED_ACT = @"ABOUT_PRESSED_ACT;";
NSString *const RATING_ACT = @"RATING_ACT;";
NSString *const FEEDBACK_SENT_ACT = @"FEEDBACK_SENT_ACT;";
NSString *const NOTES_EMPTY_SCREEN_ACT = @"NOTES_EMPTY_SCREEN_ACT;";
NSString *const NOTE_SELECTED_ACT = @"NOTE_SELECTED_ACT;";
NSString *const ARTICLE_PRESSED_ACT = @"ARTICLE_PRESSED_ACT;";
NSString *const LOAD_MORE_ACT = @"LOAD_MORE_ACT;";
NSString *const LOAD_MORE_FAILURE_ACT = @"LOAD_MORE_FAILURE_ACT;";
NSString *const LOAD_MORE_SUCCESS_ACT = @"LOAD_MORE_SUCCESS_ACT;";
NSString *const NAV_PRESSED_ACT = @"NAV_PRESSED_ACT;";
NSString *const NAV_DISMISSED_ACT = @"NAV_DISMISSED_ACT;";
NSString *const NAV_SELECTION_ACT = @"NAV_SELECTION_ACT;";
NSString *const SHARE_ACT = @"SHARE_ACT;";
NSString *const NOTE_SAVED_ACT = @"NOTE_SAVED_ACT;";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:GAID];
    
    [self checkAndCreateDatabase];
    [[[ApiHelper alloc] init] updateDatabase];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:openedCount]) {
        int count = [userDefaults integerForKey:openedCount];
        [userDefaults setInteger:count+1 forKey:openedCount];
    } else {
        [userDefaults setInteger:1 forKey:openedCount];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
         self.homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewControllerTall" bundle:nil];
    } else {
         self.homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }
    
    UINavigationController *hnc = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    
    self.navController = hnc;
    [self.navController navigationBar].hidden = YES;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) checkAndCreateDatabase{
    NSString *databaseName = @"bacc_wp.db";
	// Get the path to the Library directory and append the databaseName
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains
	(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDir = [libraryPaths objectAtIndex:0];
	// the directory path for the Databases.db file
	// the directory path for the 0000000000000001.db file
		NSString *databasePath = [libraryDir stringByAppendingPathComponent:@"WP/"];
	// the full path for the Databases.db file
	// the full path for the 0000000000000001.db file
		NSString *databaseFile = [databasePath
					stringByAppendingPathComponent:databaseName];
	// Check if the SQL database has already been saved to the users
	// phone, if not then copy it over
	BOOL success;
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// Check if the database has already been created in the users
	// filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	// If the database already exists then return without doing anything
	if(success) return;
    
    [self copyOverImages];
	// If not then proceed to copy the database from the application to
	// the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]
									 stringByAppendingPathComponent:databaseName];
	// Create the database folder structure
	[fileManager createDirectoryAtPath:databasePath
		   withIntermediateDirectories:YES attributes:nil error:NULL];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databaseFile
						  error:nil];
}

-(void)copyOverImages
{
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * documentsPath = resourcePath;
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    for (NSString *fname in directoryContents) {

        if ( [fname hasPrefix:@"blurred"] || [fname hasPrefix:@"cropped"] ){
            NSData *imgData = [[NSFileManager defaultManager] contentsAtPath:[documentsPath stringByAppendingPathComponent:fname]];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fname];
            [imgData writeToFile:filePath atomically:YES];
        }
    }
}

-(void) saveImage:(UIImage*)image withName:(NSString*)fname {
    NSData *imgData = UIImagePNGRepresentation(image);
    
    if ( imgData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fname];
        [imgData writeToFile:filePath atomically:YES];
        
    }
    
}

-(UIImage*) loadImage:(NSString*)fname
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fname];
    return [UIImage imageWithContentsOfFile:filePath];
}

-(void)deleteImage:(NSString*)fname
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fname];
    
    [fileManager removeItemAtPath:filePath error:NULL];
}

-(FMDatabase*)getDatabase {
    if (!_database) {
        NSString *databaseName = @"bacc_wp.db";
        NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains
        (NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDir = [libraryPaths objectAtIndex:0];
        // the directory path for the Databases.db file
        // the directory path for the 0000000000000001.db file
		NSString *databasePath = [libraryDir stringByAppendingPathComponent:@"WP/"];
        //NSLog(databasePath);
        // the full path for the Databases.db file
        // the full path for the 0000000000000001.db file
		NSString *databaseFile = [databasePath
                                  stringByAppendingPathComponent:databaseName];
        _database = [FMDatabase databaseWithPath:databaseFile];
    }
    
    if (![_database open]) {
        return nil;
    }
    
    return _database;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

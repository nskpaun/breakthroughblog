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

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkAndCreateDatabase];
    [[[ApiHelper alloc] init] updateDatabase];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
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


-(FMDatabase*)getDatabase {
    if (!_database) {
        NSString *databaseName = @"bacc_wp.db";
        NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains
        (NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDir = [libraryPaths objectAtIndex:0];
        // the directory path for the Databases.db file
        // the directory path for the 0000000000000001.db file
		NSString *databasePath = [libraryDir stringByAppendingPathComponent:@"WP/"];
        NSLog(databasePath);
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

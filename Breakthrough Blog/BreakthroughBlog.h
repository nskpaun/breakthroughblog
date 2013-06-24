//
//  BreakthroughBlog.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FMDatabase.h"
#define BreakthroughBlogAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define mentDarkGray [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:0.25f]
#define mentLightGreen [UIColor colorWithRed:227.0/255.0 green:255.0/255.0 blue:222.0/255.0 alpha:1.0f]
#define mentLightOrange [UIColor colorWithRed:255.0/255.0 green:168.0/255.0 blue:76.0/255.0 alpha:1.0f]
#define mentMediumGray [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0f]

@interface BreakthroughBlogSingleton : NSObject

@end

extern BreakthroughBlogSingleton *BreakthroughBlog;
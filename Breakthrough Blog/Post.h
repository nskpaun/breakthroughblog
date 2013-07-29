//
//  Post.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, copy) NSString* pid;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* permalink;
@property (nonatomic, copy) NSString* htmlContent;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* excerpt;
@property (nonatomic, copy) NSString* picUrl;
@property (nonatomic, copy) NSString* category;
@property (nonatomic, strong) NSDate* postDate;
@property (nonatomic, strong) UIImage* postImage;
@property (nonatomic, strong) UIImage* croppedImage;
@property (nonatomic, strong) UIImage* blurredImage;
@property (nonatomic, strong) UIImageView* tempImageView;
@property (nonatomic) BOOL isNew;

extern int dbPostsPerCategory;
extern int postThresholdForNew;

extern NSString *const PURPOSE;
extern NSString *const PASSION;
extern NSString *const COMPASSION;
extern NSString *const CONVICTION;

+(Post*)getPostById:(NSString*)idStr;
+(NSArray*)postsFromJSON:(NSArray*)array;
+(NSArray*)firstFromEachCategory;
+(NSArray*)postsForCategory:(NSString*)category;
+(NSArray*)postsWithNotes;
+(void)loadPostsIntoDatabase:(NSArray*)array;
+(int)newPostsForCategroy:(NSString*)category;
+(void)updateCache:(NSString*)category posts:(NSArray*)posts;

-(void)save;
-(void)markAsRead;
-(void)loadPostImage:(BOOL)saveToDisk;


@end

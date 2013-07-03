//
//  Post.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "Post.h"
#import "BreakthroughBlog.h"
#import "ImageDownload.h"
#import "FMDatabaseAdditions.h"

static NSMutableDictionary *postCache;

@implementation Post

int dbPostsPerCategory = 5;
int postThresholdForNew = 604800;

@synthesize pid;
@synthesize title;
@synthesize permalink;
@synthesize htmlContent;
@synthesize author;
@synthesize excerpt;
@synthesize picUrl;
@synthesize postDate;
@synthesize category;
@synthesize postImage;
@synthesize tempImageView;
@synthesize croppedImage;
@synthesize blurredImage;
@synthesize isNew;

NSString *ID_KEY = @"ID";
NSString *TITLE_KEY = @"TITLE";
NSString *LINK_KEY = @"LINK";
NSString *CONTENT_KEY = @"CONTENT";
NSString *AUTHOR_KEY = @"AUTHOR";
NSString *EXCERPT_KEY = @"EXCERPT";
NSString *PICURL_KEY = @"PICURL";
NSString *POSTDATE_KEY = @"POSTDATE";
NSString *CATEGORY_KEY = @"CATEGORY";
NSString *NEW_KEY = @"new";

NSString *const PASSION = @"Passion";
NSString *const COMPASSION = @"Compassion";
NSString *const CONVICTION = @"Conviction";
NSString *const PURPOSE = @"Purpose";

+(Post*)getPostById:(NSString*)idStr
{
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    FMResultSet *result = [ db executeQuery:@"SELECT * FROM Post where ID = (?);",idStr];
    
    if ([result next]) {
        return [Post postFromResultSet:result];
    }
    
    return nil;
}

+(NSArray*)firstFromEachCategory
{
    NSString *cacheKey = @"firsts";
    if (postCache) {
        NSArray *cached = [postCache objectForKey:cacheKey];
        if (cached) {
            return cached;
        }
    } else {
        postCache = [[NSMutableDictionary alloc] init];
    }
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *result = [ db executeQuery:@"SELECT * FROM Post where CATEGORY = 'Passion' order by postdate desc;"];
    [result next];
    [array addObject:[Post postFromResultSet:result]];
    
    result = [ db executeQuery:@"SELECT * FROM Post where CATEGORY = 'Purpose' order by postdate desc;"];
    [result next];
    [array addObject:[Post postFromResultSet:result]];
    
    result = [ db executeQuery:@"SELECT * FROM Post where CATEGORY = 'Conviction' order by postdate desc;"];
    [result next];
    [array addObject:[Post postFromResultSet:result]];
    
    result = [ db executeQuery:@"SELECT * FROM Post where CATEGORY = 'Compassion' order by postdate desc;"];
    [result next];
    [array addObject:[Post postFromResultSet:result]];
    
    [postCache setObject:array forKey:cacheKey];
    
    [db close];
    
    return array;
}

+(NSArray*)postsWithNotes
{

    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    FMResultSet *result = [ db executeQuery:@"SELECT DISTINCT POST FROM NOTE order by editeddate desc"];
    
    while ([result next]){
        [array addObject:[Post getPostById:[result stringForColumn:@"POST"]]];
    }
    
    return array;
    
    
}

+(NSArray*)postsForCategory:(NSString*)category {
    
    NSString *cacheKey =[ NSString stringWithFormat:@"%@_cat",category ];
    if (postCache) {
        NSArray *cached = [postCache objectForKey:cacheKey];
        if (cached) {
            return cached;
        }
    } else {
        postCache = [[NSMutableDictionary alloc] init];
    }
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [ db executeQuery:@"SELECT * FROM Post where CATEGORY = (?) order by postdate desc limit 5;",category];
    while ([result next]){
        [array addObject:[Post postFromResultSet:result]];
    }

    [db close];
    
    [postCache setObject:array forKey:cacheKey];
    
    return array;
}

+(void)updateCache:(NSString*)category posts:(NSArray*)posts
{

    NSString *cacheKey =[ NSString stringWithFormat:@"%@_cat", [category capitalizedString] ];
    if (postCache) {
        [postCache setObject:posts forKey:cacheKey];
    } else {
        postCache = [[NSMutableDictionary alloc] init];
        [postCache setObject:posts forKey:cacheKey];
    }
}



+(Post*)postFromResultSet:(FMResultSet*)result
{
    Post *post = [[Post alloc] init];
    post.pid = [result stringForColumn:ID_KEY];
    post.title = [result stringForColumn:TITLE_KEY];
    post.permalink = [result stringForColumn:LINK_KEY];
    post.htmlContent = [result stringForColumn:CONTENT_KEY];
    post.author = [result stringForColumn:AUTHOR_KEY];
    post.excerpt = [result stringForColumn:EXCERPT_KEY];
    post.category = [result stringForColumn:CATEGORY_KEY];
    post.picUrl = [result stringForColumn:PICURL_KEY];
    int seconds = [result intForColumn:POSTDATE_KEY];
    if ( ([[NSDate date] timeIntervalSince1970] - postThresholdForNew) < seconds && [result intForColumn:NEW_KEY] == 1 ) {
        post.isNew = YES;
    } else {
        post.isNew = NO;
    }
    post.postDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    [post loadPostImage];
    
    return post;
}

-(void)loadPostImage
{
    dispatch_queue_t queue = dispatch_queue_create("cc.bacc.BreakthroughBlog", NULL);
    dispatch_async(queue, ^{

        self.postImage = [ImageDownload imageForUrl:self.picUrl];
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.postImage CGImage], CGRectMake(0, 0, 320, 104));
        self.croppedImage = [UIImage imageWithCGImage:imageRef];
        
        CIImage *inputImage = [[CIImage alloc] initWithImage:self.postImage];
        CIFilter * controlsFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [controlsFilter setValue:inputImage forKey:kCIInputImageKey];
        [controlsFilter setValue:[NSNumber numberWithFloat: 5.0f] forKey:@"inputRadius"];
        CIImage *displayImage = controlsFilter.outputImage;
        UIImage *finalImage = [UIImage imageWithCIImage:displayImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        if (displayImage == nil || finalImage == nil) {
            // We did not get output image. Let's display the original image itself.
            self.blurredImage = self.postImage;
        }else {
            // We got output image. Display it.
            self.blurredImage = [UIImage imageWithCGImage:[context createCGImage:displayImage fromRect:displayImage.extent]];
        }
        

//        self.blurredImage = [UIImage imageWithCIImage:outputImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tempImageView) {
                if ( self.tempImageView.frame.size.height>300) {
                    

                    
                    [self.tempImageView setImage:self.blurredImage];
                    
                    
                    
                } else {
                    [self.tempImageView setImage:self.croppedImage];
                }

            }
        });
    });
}

-(void)save
{
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];

    NSNumber *millis = [NSNumber numberWithInteger: [postDate timeIntervalSince1970]];
    [ db executeUpdate:@"INSERT INTO POST (ID,TITLE,LINK,CONTENT,AUTHOR,EXCERPT,PICURL,POSTDATE,CATEGORY,new) VALUES ( (?),(?),(?),(?),(?),(?),(?),(?),(?),1 ) ;",pid,title,permalink,htmlContent,author,excerpt,picUrl,millis,category];
    
    [db close];
}

+(void)cleanDB
{
        FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
        NSString *deleteString = @"DELETE FROM post WHERE id NOT IN (SELECT DISTINCT POST FROM NOTE) AND id NOT IN ( SELECT p1.id FROM POST p1 WHERE p1.category = (?) ORDER BY p1.postdate DESC LIMIT 5) AND category = (?);";
        [ db executeUpdate:deleteString,PASSION, PASSION];
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [ db executeUpdate:deleteString,COMPASSION, COMPASSION];
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [ db executeUpdate:deleteString,PURPOSE,  PURPOSE];
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [ db executeUpdate:deleteString,CONVICTION, CONVICTION];
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        
        [db close];
}

+(void)loadPostsIntoDatabase:(NSArray*)array
{
    dispatch_queue_t queue = dispatch_queue_create("cc.bacc.BreakthroughBlog.db", NULL);
    dispatch_async(queue, ^{
        for (Post *post in [Post postsFromJSON:array]) {
            [post save];
        }
        
        [Post cleanDB];
        
    });
}
+(NSArray*)postsFromJSON:(NSArray*)array
{
    NSMutableArray* postObjects = [[NSMutableArray alloc] init];
    for ( NSDictionary *dict in array ) {
        NSString *category = [dict objectForKey:@"name"];
        NSArray *posts = [dict objectForKey:@"posts"];
        for (NSDictionary *postDict in posts) {
            Post *post = [[Post alloc] init];
            post.pid = [postDict objectForKey:@"id"];
            post.author = [postDict objectForKey:@"author"];
            NSString *dateString = [postDict objectForKey:@"date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            post.postDate = [dateFormat dateFromString:dateString];
            
            post.title = [postDict objectForKey:@"title"];
            post.permalink = [postDict objectForKey:@"link"];
            post.htmlContent = [postDict objectForKey:@"content"];
            NSString *contentNoHtml = [Post stringByStrippingHTML:post.htmlContent];
            if (contentNoHtml.length > 100) {
                post.excerpt = [contentNoHtml substringToIndex:99];
            } else {
                post.excerpt = @"No Excerpt Available";
            }
            
            NSArray *array = [postDict objectForKey:@"images"];
            
            post.picUrl = [array objectAtIndex:0];
            post.category = category;
            
            [postObjects addObject:post];
            
        }
        
    }
    
    return postObjects;
}

-(void)markAsRead
{
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    [postCache removeObjectForKey:self.category];
    [db executeUpdate: @"UPDATE post SET new=0 WHERE ID=(?);", self.pid ];
    [db close];
}

+(NSString *) stringByStrippingHTML:(NSString*)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


+(int)newPostsForCategroy:(NSString*)category
{
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];

    int count = [db intForQuery:@"select count(*) from post where category = (?) and postdate > (?) and new = 1;",category, [NSNumber numberWithInt:([[NSDate date] timeIntervalSince1970] - postThresholdForNew)]];

    
    [db close];
    
    return count;
}
@end

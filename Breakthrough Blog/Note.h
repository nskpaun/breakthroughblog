//
//  Note.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/14/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic,strong) NSNumber *nid;
@property (nonatomic,strong) NSNumber *question;
@property (nonatomic,copy) NSString *post;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) NSDate *editedDate;

-(id)initWithQuestion:(NSNumber*)question withPost:(NSString*)post withText:(NSString*)text;
-(NSNumber*)save;
-(void)update;
+(NSArray*)getNotesForPostId:(NSString*)postId;
+(Note*)getNoteForPostId:(NSString*)postId andQuestion:(NSNumber*)q;

@end

//
//  Note.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/14/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "Note.h"
#import "BreakthroughBlog.h"

static NSMutableDictionary *noteCache;

@implementation Note

@synthesize text;
@synthesize post;
@synthesize question;
@synthesize nid;
@synthesize editedDate;

NSString *NID_KEY = @"ID";
NSString *TEXT_KEY = @"CONTENT";
NSString *DATE_KEY = @"EDITEDDATE";
NSString *POST_KEY = @"POST";
NSString *QUESTION_KEY = @"QUESTION";

-(id)initWithQuestion:(NSNumber*)q withPost:(NSString*)p withText:(NSString*)t
{
    self = [super init];
    if (self) {
        post = p;
        text = t;
        question = q;
    }
    return self;
}

+(NSArray*)getNotesForPostId:(NSString*)postId
{
    NSMutableArray *notes = nil;
    if (noteCache) {
        notes= [noteCache objectForKey:postId];
    } else {
        noteCache = [[NSMutableDictionary alloc] init];
    }
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    
    notes = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [ db executeQuery:@"SELECT * FROM Note where POST = (?);",postId];
    while ([result next]){
        [notes addObject:[Note noteFromResultSet:result]];
    }
    
    [db close];
    
    return notes;
}
+(Note*)noteFromResultSet:(FMResultSet*)result
{
    Note *note = [[Note alloc] init];
    
    note.nid = [NSNumber numberWithInt:[result intForColumn:NID_KEY]];
    note.text = [result stringForColumn:TEXT_KEY];
    note.post = [result stringForColumn:POST_KEY];
    note.question = [NSNumber numberWithInt:[result intForColumn:QUESTION_KEY]];
    note.editedDate = [NSDate dateWithTimeIntervalSince1970:[result longForColumn:DATE_KEY]];
    
    return note;
}

+(Note*)getNoteForPostId:(NSString*)postId andQuestion:(NSNumber*)q
{
    Note *note = nil;
    if (noteCache) {
        note= [[noteCache objectForKey:postId] objectForKey:q];
    } else {
        noteCache = [[NSMutableDictionary alloc] init];
    }
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    
    FMResultSet *result = [ db executeQuery:@"SELECT * FROM Note where POST = (?) and QUESTION = (?);",postId,q];
    while ([result next]){
        note = [Note noteFromResultSet:result];
    }
    
    [db close];
    
    return note;
}

-(NSNumber*)save
{
    self.editedDate = [NSDate date];
    NSMutableDictionary *postQs = [noteCache objectForKey:self.post];
    if (postQs) {
        [postQs setObject:self forKey:self.question];
    } else {
        postQs = [[NSMutableDictionary alloc] init];
        [postQs setObject:self forKey:self.question];
    }
    [noteCache setObject:postQs forKey:self.post];
    
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    NSNumber *millis = [NSNumber numberWithInteger: CFAbsoluteTimeGetCurrent()];
    [ db executeUpdate:@"INSERT INTO NOTE (CONTENT,QUESTION,POST,EDITEDDATE) VALUES ( (?),(?),(?),(?) ) ;",self.text,self.question,self.post, millis];
    
    [db close];
    return [NSNumber numberWithInteger:0];
}

-(void)update
{
    FMDatabase *db = [BreakthroughBlogAppDelegate getDatabase];
    [db executeUpdate: @"UPDATE note SET content=(?) WHERE Id=(?);", self.text, self.nid ];
    [db close];
}



@end

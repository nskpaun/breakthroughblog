//
//  ArticleFormatter.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface ArticleFormatter : NSObject

+(NSString*)formatPostToHtml:(Post*)post;

@end

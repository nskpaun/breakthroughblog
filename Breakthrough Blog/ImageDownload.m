//
//  ImageDownload.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload

+(UIImage*)imageForUrl:(NSString*)urlString
{
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
    return [UIImage imageWithData: imageData];
}

@end

//
//  ReadViewController.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface ReadViewController : UIViewController {
    Post *post;
    NSString *category;
    
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIWebView *contentView;
    
}

-(id)initWithPost:(Post*)post withCategory:(NSString*)category;


@end

//
//  ShareView.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 7/10/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ShareView : UIView <MFMailComposeViewControllerDelegate> {
    Post *_post;
    SLComposeViewController *mySLComposerSheet;
}

- (id)initWithFrame:(CGRect)frame withPost:(Post*)post;

@end

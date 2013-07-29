//
//  ShareView.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 7/10/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "ShareView.h"
#import "BreakthroughBlog.h"
#import <Twitter/Twitter.h>

@implementation ShareView

- (id)initWithFrame:(CGRect)frame withPost:(Post*)post
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        _post = post;
    }
    return self;
}



- (IBAction)emailPressed:(id)sender {
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"EMAIL_PRESSED" withValue:0];
    if([MFMailComposeViewController canSendMail]) {
        NSString *body = [NSString stringWithFormat:@"Link to Article: %@ \n \t%@", _post.permalink,_post.htmlContent];
        NSString *subject = [NSString stringWithFormat:@"Breakthrough Article: %@",_post.title];
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:subject];
        [mailCont setMessageBody:body isHTML:YES];
        [BreakthroughBlogAppDelegate.navController presentModalViewController:mailCont animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [BreakthroughBlogAppDelegate.navController dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"EMAIL_SENT" withValue:0];
    } else {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"EMAIL_CANCELLED" withValue:0];
    }
    
    [self removeFromSuperview];
}

- (IBAction)twitterPressed:(id)sender {
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"TWITTER_PRESSED" withValue:0];
    if ([TWTweetComposeViewController canSendTweet])
    {
        NSString *initialText = [NSString stringWithFormat:@"Breakthrough Article: %@ %@",_post.title,_post.permalink];
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:initialText];
        [BreakthroughBlogAppDelegate.navController presentModalViewController:tweetSheet animated:YES];
    }
    [self removeFromSuperview];
}
- (IBAction)facebookPressed:(id)sender {
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"FACEBOOK_PRESSED" withValue:0];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        NSString *initialText = [NSString stringWithFormat:@"Breakthrough Article: %@ \n %@",_post.title,_post.permalink];
        [mySLComposerSheet setInitialText:initialText]; //the message you want to post
        //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
        [BreakthroughBlogAppDelegate.navController presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"FACEBOOK_CANCELLED" withValue:0];
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"FACEBOOK_SENT" withValue:0];
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    [self removeFromSuperview];
}
- (IBAction)cancelPressed:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

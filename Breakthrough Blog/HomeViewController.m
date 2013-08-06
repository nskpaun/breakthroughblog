//
//  HomeViewController.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "HomeViewController.h"
#import "Post.h"
#import "DrillDownViewController.h"
#import "BreakthroughBlog.h"
#import "AboutUsViewController.h"
#import  <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        // Custom initialization
    }
    return self;
}
- (IBAction)aboutPressed:(id)sender {
    AboutUsViewController *auvc = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [BreakthroughBlogAppDelegate.navController pushViewController:auvc animated:YES];
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:ABOUT_PRESSED_ACT withLabel:@"" withValue:0];
    
    
}
- (IBAction)myNotesPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsWithNotes] withCategory:@"MY NOTES"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:NOTE_PRESSED_ACT withLabel:@"" withValue:0];
}
- (IBAction)navigationPressed:(id)sender {
    if (_navMenu.superview) {
        [_navMenu removeFromSuperview];
    } else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
        else
            UIGraphicsBeginImageContext(window.bounds.size);
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIGraphicsEndImageContext();
        [self.view addSubview:_navMenu];
    }
}
- (IBAction)compassionPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsForCategory:COMPASSION] withCategory:@"COMPASSION"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
}
- (IBAction)convictionPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsForCategory:CONVICTION] withCategory:@"CONVICTION"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
}
- (IBAction)passionPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsForCategory:PASSION] withCategory:@"PASSION"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
}
- (IBAction)purposePressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsForCategory:PURPOSE] withCategory:@"PURPOSE"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    _navMenu = [NavigationPopoverView navigationView];
    NSArray *topFour = [Post firstFromEachCategory];
    
    Post *p0 = [topFour objectAtIndex:0];
    p0.tempImageView = passionImage;
    [passionImage setImage:p0.croppedImage];
    
    Post *p1 = [topFour objectAtIndex:1];
    p1.tempImageView = purposeImage;
    [purposeImage setImage:p1.croppedImage];
    
    Post *p2 = [topFour objectAtIndex:2];
    p2.tempImageView = convictionImage;
    [convictionImage setImage:p2.croppedImage];
    
    Post *p3 = [topFour objectAtIndex:3];
    p3.tempImageView = compassionImage;
    [compassionImage setImage:p3.croppedImage];

    if ([Post newPostsForCategroy:COMPASSION]==0) {
        compassionCounter.hidden = YES;
        compassionAct.hidden = YES;
    } else {
        compassionCounter.hidden = NO;
        compassionAct.hidden = NO;
    }
    
    
    if ([Post newPostsForCategroy:PASSION]==0) {
        passionCounter.hidden = YES;
        passionAct.hidden = YES;
    } else {
        passionCounter.hidden = NO;
        passionAct.hidden = NO;
    }
    
    if ([Post newPostsForCategroy:PURPOSE]==0) {
        purposeCounter.hidden = YES;
        purposeAct.hidden = YES;
    } else {
        purposeCounter.hidden = NO;
        purposeAct.hidden = NO;
    }
    
    if ([Post newPostsForCategroy:CONVICTION]==0) {
        convictionCounter.hidden = YES;
        convictionAct.hidden = YES;
    } else {
        convictionCounter.hidden = NO;
        convictionAct.hidden = NO;
    }
    
    [compassionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:COMPASSION]  ]];
    [convictionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:CONVICTION]  ]];
    [passionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:PASSION]  ]];
    [purposeCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:PURPOSE]  ]];
    
    int openCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"openedCount"];
    
    if (openCount > -1 && openCount%2==0 && openCount < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Us"
                                                        message:@"We hope you are enjoying BACC Breakthroughs. Please help promote our app and make it better."
                                                       delegate:self
                                              cancelButtonTitle:@"Later"
                                              otherButtonTitles:@"Show Love",@"Give Feedback",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 2 ) {
        
        NSString *email = @"appfeedback@bacc.cc";
        
        if([MFMailComposeViewController canSendMail]) {
            [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:RATING_ACT withLabel:@"FEEDBACK" withValue:[NSNumber numberWithInt:buttonIndex ]];
            NSString *subject = @"Feedback for iOS App";
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            [mailCont setToRecipients:[NSArray arrayWithObject:email]];
            [mailCont setSubject:subject];
            [BreakthroughBlogAppDelegate.navController presentModalViewController:mailCont animated:YES];
        }
        
    } else if (buttonIndex == 1) {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:RATING_ACT withLabel:@"RATING" withValue:[NSNumber numberWithInt:buttonIndex ]];
        [[NSUserDefaults standardUserDefaults] setInteger:-5 forKey:@"openedCount"];
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
        str = [NSString stringWithFormat:@"%@id=", str];
        
        // Here is the app id from itunesconnect
        str = [NSString stringWithFormat:@"%@yourAppIDHere", str];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } else {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:RATING_ACT withLabel:@"LATER" withValue:[NSNumber numberWithInt:buttonIndex ]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [BreakthroughBlogAppDelegate.navController dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:HOME_CAT withAction:FEEDBACK_SENT_ACT withLabel:@"" withValue:[NSNumber numberWithInt:result ]];
        [[NSUserDefaults standardUserDefaults] setInteger:-5 forKey:@"openedCount"];
    }
        
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([Post newPostsForCategroy:COMPASSION]==0) {
        compassionCounter.hidden = YES;
        compassionAct.hidden = YES;
    } else {
        compassionCounter.hidden = NO;
        compassionAct.hidden = NO;
    }
    
    
    if ([Post newPostsForCategroy:PASSION]==0) {
        passionCounter.hidden = YES;
        passionAct.hidden = YES;
    } else {
        passionCounter.hidden = NO;
        passionAct.hidden = NO;
    }
    
    if ([Post newPostsForCategroy:PURPOSE]==0) {
        purposeCounter.hidden = YES;
        purposeAct.hidden = YES;
    } else {
        purposeCounter.hidden = NO;
        purposeAct.hidden = NO;
    }
    
    if ([Post newPostsForCategroy:CONVICTION]==0) {
        convictionCounter.hidden = YES;
        convictionAct.hidden = YES;
    } else {
        convictionCounter.hidden = NO;
        convictionAct.hidden = NO;
    }
    
    [compassionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:COMPASSION]  ]];
    [convictionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:CONVICTION]  ]];
    [passionCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:PASSION]  ]];
    [purposeCounter setText:[NSString stringWithFormat:@"%d",[Post newPostsForCategroy:PURPOSE]  ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    passionImage = nil;
    purposeImage = nil;
    convictionImage = nil;
    compassionImage = nil;
    passionCounter = nil;
    purposeCounter = nil;
    convictionCounter = nil;
    compassionCounter = nil;
    purposeAct = nil;
    convictionAct = nil;
    compassionAct = nil;
    passionAct = nil;
    compassionView = nil;
    convictionView = nil;
    purposeView = nil;
    passionView = nil;
    [super viewDidUnload];
}
@end

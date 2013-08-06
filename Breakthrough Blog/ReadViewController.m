//
//  ReadViewController.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "ReadViewController.h"
#import "BreakthroughBlog.h"
#import "ArticleFormatter.h"
#import "Note.h"
#import "ShareView.h"
#import <QuartzCore/QuartzCore.h>

@interface ReadViewController ()

@end

@implementation ReadViewController

-(id)initWithPost:(Post*)p withCategory:(NSString*)cat
{
    self = [super initWithNibName:@"ReadViewController" bundle:nil];
    if (self) {
        post = p;
        p.isNew = NO;
        [p markAsRead];
        category = cat;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [titleLabel setText:post.title];
    
    [Note getNotesForPostId:post.pid];
    post.tempImageView = backgroundImage;
    [[webViewContainer layer] setCornerRadius:3];
    
    NSString *baseUrlString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"baseurl"];

    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@/", [baseUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];

    [contentView loadHTMLString:[ArticleFormatter formatPostToHtml:post] baseURL:baseUrl];

    [backgroundImage setImage:post.blurredImage];
}
- (IBAction)shareButtonPressed:(id)sender {
    ShareView *sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withPost:post];
    [self.view addSubview:sv];
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:SHARE_ACT withLabel:@"PRESSED" withValue:0];
}

- (IBAction)backButtonPressed:(id)sender {
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:READ_CAT withAction:BACK_PRESSED_ACT withLabel:@"" withValue:0];
    

    NSInteger questions = [[contentView stringByEvaluatingJavaScriptFromString:@"$('textarea').length"] integerValue];
    
    NSString *txtNotes = @"t";

    for (NSInteger i = 0; i < questions; i++) {
        txtNotes = [NSString stringWithString:[contentView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.getElementById('target%d').value",i]]];
        Note *existing = [Note getNoteForPostId:post.pid andQuestion:[NSNumber numberWithInt:i]];
        if ( existing && ![existing.text isEqualToString:txtNotes] ) {
            existing.text = txtNotes;
            [existing update];
        } else if (txtNotes.length>0 && !existing) {
            [post save];
            Note *note = [[Note alloc] initWithQuestion:[NSNumber numberWithInteger:i] withPost:post.pid withText:txtNotes];
            [note save];
        }
    }

    [BreakthroughBlogAppDelegate.navController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    backgroundImage = nil;
    contentView = nil;
    titleLabel = nil;
    webViewContainer = nil;
    [super viewDidUnload];
}
@end

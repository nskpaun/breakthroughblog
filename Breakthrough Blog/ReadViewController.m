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
    [contentView loadHTMLString:[ArticleFormatter formatPostToHtml:post] baseURL:[NSURL URLWithString:@"http://noah.tecarta.com/grow/"]];

    [backgroundImage setImage:post.blurredImage];
}

- (IBAction)backButtonPressed:(id)sender {
    

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

    [BreakthroughBlogAppDelegate.navController popViewControllerAnimated:YES];
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
    [super viewDidUnload];
}
@end

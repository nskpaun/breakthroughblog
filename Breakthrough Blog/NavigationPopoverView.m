//
//  NavigationPopoverView.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "NavigationPopoverView.h"
#import "DrillDownViewController.h"
#import "BreakthroughBlog.h"
#import "Post.h"

@implementation NavigationPopoverView

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (IBAction)compassionButton:(id)sender {
}

+(NavigationPopoverView*)navigationView
{
    NavigationPopoverView *result;
    
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            result = anObject;
            break;
        }
    }
    result.frame = CGRectMake(0,44, 320, 239);
    return result;
}

- (IBAction)purposePressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsForCategory:PURPOSE] withCategory:@"PURPOSE"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
}

- (IBAction)mynotesPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsWithNotes] withCategory:@"MY NOTES"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

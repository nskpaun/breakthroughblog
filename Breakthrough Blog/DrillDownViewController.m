//
//  DrillDownViewController.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "DrillDownViewController.h"
#import "Post.h"
#import "PostPreviewCell.h"
#import "BreakthroughBlog.h"
#import "ReadViewController.h"
#import "ApiHelper.h"

@interface DrillDownViewController ()

@end

@implementation DrillDownViewController

-(id)initWithPosts:(NSArray*)p withCategory:(NSString*)c {

    self = [super initWithNibName:@"DrillDownViewController" bundle:nil];
    if (self) {
        posts = p;
        category = c;
        _navMenu = [NavigationPopoverView navigationView];
        if ([category isEqualToString:@"COMPASSION"]) {
            [_navMenu.compassionLabel setTextColor:[UIColor whiteColor]];
            [_navMenu.compassionButton removeFromSuperview];
            [_navMenu.compassionView setBackgroundColor:[UIColor blueColor]];
            
        } else if ([category isEqualToString:@"PASSION"]) {
            [_navMenu.passionLabel setTextColor:[UIColor whiteColor]];
            [_navMenu.passionButton removeFromSuperview];
            [_navMenu.passionView setBackgroundColor:[UIColor blueColor]];
            
        } else if ([category isEqualToString:@"PURPOSE"]) {
            [_navMenu.purposeLabel setTextColor:[UIColor whiteColor]];
            [_navMenu.purposeButton removeFromSuperview];
            [_navMenu.purposeView setBackgroundColor:[UIColor blueColor]];
            
        } else if ([category isEqualToString:@"CONVICTION"]) {
            [_navMenu.convictionLabel setTextColor:[UIColor whiteColor]];
            [_navMenu.convictionButton removeFromSuperview];
            [_navMenu.convictionView setBackgroundColor:[UIColor blueColor]];
            
        } else if ([category isEqualToString:@"MY NOTES"]) {
            [_navMenu.notesLabel setTextColor:[UIColor whiteColor]];
            [_navMenu.notesButton removeFromSuperview];
            [_navMenu.notesView setBackgroundColor:[UIColor blueColor]];
            
        }
    }
    return self;
}
-(void)viewDidAppear:(BOOL)appear
{
    [postTable reloadData];
}

- (IBAction)backPressed:(id)sender {
    [BreakthroughBlogAppDelegate.navController popToRootViewControllerAnimated:YES];
}

- (IBAction)navPressed:(id)sender {
    if (_navMenu.superview) {
        [_navMenu removeFromSuperview];
    } else {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
        [self.view addSubview:_navMenu];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [titleLabel setText:category];
    loadingMore = NO;
    page = (posts.count+5-1)/5;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    titleLabel = nil;
    postTable = nil;
    [super viewDidUnload];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [posts objectAtIndex:indexPath.row];
    
    PostPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostPreview"];
    
    if (!cell) {
        cell = [[PostPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostPreview"];

    }
    [cell.drilldownTitle setText:post.title];

    [cell.drilldownExcerpt setText:post.excerpt];

    [cell.drilldownImage setImage:post.croppedImage];
    post.tempImageView = cell.drilldownImage;
    
    cell.bannerNewIndicator.hidden = !post.isNew;
    
    [cell.drilldownTitle setFont:[UIFont fontWithName:@"Avenir-Heavy" size:19.0]];
    [cell.drilldownTitle setTextColor:[UIColor whiteColor]];
    [cell.drilldownExcerpt setTextColor:[UIColor whiteColor]];
    [cell.drilldownExcerpt setFont:[UIFont fontWithName:@"Avenir-MediumOblique" size:14.0]];

    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [posts objectAtIndex:indexPath.row];
    ReadViewController *rvc = [[ReadViewController alloc] initWithPost:post withCategory:category];
    [BreakthroughBlogAppDelegate.navController pushViewController:rvc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y > h + reload_distance && !loadingMore) {
        loadingMore = YES;
        
        void (^callback)(NSArray*) = ^(NSArray* array) {
            NSArray *parsedArray = [Post postsFromJSON:array];
            for ( Post *post in parsedArray) {
                [post loadPostImage];
            }
            NSMutableArray *newPosts = [[NSMutableArray alloc] initWithArray:posts];
            
            [newPosts addObjectsFromArray:parsedArray];
            posts = newPosts;
            [Post updateCache:category posts:posts];
            [postTable reloadData];
            if (parsedArray.count>1){
                page++;
                loadingMore = NO;
            }
        
            
        };
        
        ApiHelper *helper = [[ApiHelper alloc] init];

        [helper getPage:page+1 forCategory:category withCallback:callback];
    }
}

@end

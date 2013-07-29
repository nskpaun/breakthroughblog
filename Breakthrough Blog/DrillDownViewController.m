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
    gaCategory = [NSString stringWithFormat:@"%@ + %@",DRILL_CAT,category];

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
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:BACK_PRESSED_ACT withLabel:@"" withValue:0];
    [BreakthroughBlogAppDelegate.navController popToRootViewControllerAnimated:YES];
}
- (IBAction)myNotesPressed:(id)sender {
    DrillDownViewController *ddvc = [[DrillDownViewController alloc] initWithPosts:[Post postsWithNotes] withCategory:@"MY NOTES"];
    [BreakthroughBlogAppDelegate.navController pushViewController:ddvc animated:YES];
}

- (IBAction)navPressed:(id)sender {
    if (_navMenu.superview) {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:NAV_DISMISSED_ACT withLabel:@"Nav Bar" withValue:0];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [_navMenu setFrame:CGRectMake(0,-151, 320, 416)];
                         } completion:^(BOOL finished) {
                             [_navMenu removeFromSuperview];
                         }
         ];


    } else {
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:NAV_PRESSED_ACT withLabel:@"" withValue:0];
        [self.view addSubview:_navMenu];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [_navMenu setFrame:CGRectMake(0,44, 320, 416)];
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([category isEqualToString:@"MY NOTES"]) {
        myNotesButton.hidden = YES;
        if ( posts.count < 1 ) noNotesView.hidden = NO;
        noNotesView.frame = CGRectMake(0, 44, 320, 600);
    }
//    categoryDict = [[NSMutableDictionary alloc] init];
//    [categoryDict setObject:@"LOVE GOD" forKey:@"PASSION"];
//    [categoryDict setObject:@"DO GOOD" forKey:@"COMPASSION"];
//    [categoryDict setObject:@"LOVE PEOPLE" forKey:@"PURPOSE"];
//    [categoryDict setObject:@"LOVE THE BIBLE" forKey:@"CONVICTION"];
//    [categoryDict setObject:@"MY NOTES" forKey:@"MY NOTES"];
    
    [titleLabel setText: category];
    
    loadingMore = NO;
    page = (posts.count+5-1)/5;
    
    CGRect carrotFrame = carrot.frame;
    if ([category isEqualToString:@"COMPASSION"]) {
        carrotFrame.origin.x = 231;
    } else if ([category isEqualToString:@"PASSION"]) {
        carrotFrame.origin.x = 207;
    } else if ([category isEqualToString:@"PURPOSE"]) {
        carrotFrame.origin.x = 210;
    } else if ([category isEqualToString:@"CONVICTION"]) {
        carrotFrame.origin.x = 230;
    } else if ([category isEqualToString:@"MY NOTES"]) {
        carrotFrame.origin.x = 220;
    }
    
    carrot.frame = carrotFrame;
    
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
    myNotesButton = nil;
    carrot = nil;
    noNotesView = nil;
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
    [cell.authorLabel setText:post.author];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    [cell.dateLabel setText:[formatter stringFromDate:post.postDate]];

    [cell.drilldownImage setImage:post.croppedImage];
    post.tempImageView = cell.drilldownImage;
    
    cell.bannerNewIndicator.hidden = !post.isNew;
    
    [cell.drilldownTitle setFont:[UIFont fontWithName:@"Avenir-Heavy" size:24.0]];
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
    
    [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:ARTICLE_PRESSED_ACT withLabel:post.title withValue:[NSNumber numberWithBool:post.isNew]];
    
    ReadViewController *rvc = [[ReadViewController alloc] initWithPost:post withCategory:category];
    [BreakthroughBlogAppDelegate.navController pushViewController:rvc animated:NO];
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
                [post loadPostImage:NO];
            }
            
            NSMutableArray *newPosts = [[NSMutableArray alloc] initWithArray:posts];
            for (Post *np in parsedArray) {
                BOOL notExists = YES;
                for (Post *p in posts) {
                    if ( [p.pid isEqualToString:np.pid] ) notExists = NO;
                }
                if (notExists) [newPosts addObject:np];
            }
            
            posts = newPosts;
            [Post updateCache:category posts:posts];
            [postTable reloadData];
            if (parsedArray.count>1){
                page++;
                loadingMore = NO;
            }
            
            [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:LOAD_MORE_SUCCESS_ACT withLabel:@"Page" withValue:[NSNumber numberWithInt:page+1]];
        
            
        };
        
        ApiHelper *helper = [[ApiHelper alloc] init];
        
        [BreakthroughBlogAppDelegate.tracker sendEventWithCategory:gaCategory withAction:LOAD_MORE_ACT withLabel:@"Page" withValue:[NSNumber numberWithInt:page+1]];
        
        [helper getPage:page+1 forCategory:category withCallback:callback];
    }
}

@end

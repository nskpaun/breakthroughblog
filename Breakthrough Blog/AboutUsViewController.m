//
//  AboutUsViewController.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 7/8/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BreakthroughBlog.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
- (IBAction)backButtonPressed:(id)sender {
    [BreakthroughBlogAppDelegate.navController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)webButtonPressed:(id)sender {
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.bacc.cc"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

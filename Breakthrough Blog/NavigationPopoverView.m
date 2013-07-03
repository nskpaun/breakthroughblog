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

-(void)setImage:(UIImage*)image
{
    NSLog(@"%@", [CIFilter filterNamesInCategory:kCICategoryBlur]);
    // What other categories can you find?
    
    // Now let's create the filter.
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // Logging a CIFilter's attributes gives all of the information on the filter
    // and what values it accepts.
    NSLog(@"%@", [blurFilter attributes]);
    [blurFilter setDefaults];
    
    // This part is weird. Our UIImage does have a CIImage property, but there's something
    // strange about it. Option-click on "CIImage" here:
    assert(image.CIImage == 0);
    // So in some cases we don't get a CIImage from a UIImage.
    // That's ok - we can make a CIImage from the UIImage's CGImage. Hooray!
    CIImage *imageToBlur = [CIImage imageWithCGImage:image.CGImage];
    assert(imageToBlur);
    
    // iOS provides a nice constant for the input image key
    [blurFilter setValue:imageToBlur forKey:kCIInputImageKey];
    // ... but not for anything else
    [blurFilter setValue:@3.0 forKey:@"inputRadius"];
    
    // Now let's get the output image. Hope it works!
    CIImage *outputImage = blurFilter.outputImage;
    assert(outputImage);
    
    [self.transparentButton setBackgroundImage:[UIImage imageWithCIImage:outputImage] forState:UIControlStateNormal];
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
    result.frame = CGRectMake(0,44, 320, 416);
    
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

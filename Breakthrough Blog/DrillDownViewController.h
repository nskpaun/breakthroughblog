//
//  DrillDownViewController.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationPopoverView.h"

@interface DrillDownViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    NSString *gaCategory;
    
    IBOutlet UIView *noNotesView;
    IBOutlet UIImageView *carrot;
    IBOutlet UILabel *titleLabel;
    IBOutlet UITableView *postTable;
    IBOutlet UIButton *myNotesButton;
    
    NSArray *posts;
    NSString *category;
    
    NavigationPopoverView *_navMenu;
    BOOL loadingMore;
    int page;
//    NSMutableDictionary *categoryDict;
}

-(id)initWithPosts:(NSArray*)p withCategory:(NSString*)category;

@end

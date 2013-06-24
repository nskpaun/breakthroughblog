//
//  NavigationPopoverView.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationPopoverView : UIView

@property (strong, nonatomic) IBOutlet UILabel *purposeLabel;
@property (strong, nonatomic) IBOutlet UILabel *passionLabel;
@property (strong, nonatomic) IBOutlet UILabel *convictionLabel;
@property (strong, nonatomic) IBOutlet UILabel *compassionLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;

@property (strong, nonatomic) IBOutlet UIButton *passionButton;
@property (strong, nonatomic) IBOutlet UIButton *purposeButton;
@property (strong, nonatomic) IBOutlet UIButton *convictionButton;
@property (strong, nonatomic) IBOutlet UIButton *compassionButton;
@property (strong, nonatomic) IBOutlet UIButton *notesButton;

@property (strong, nonatomic) IBOutlet UIView *passionView;
@property (strong, nonatomic) IBOutlet UIView *compassionView;
@property (strong, nonatomic) IBOutlet UIView *purposeView;
@property (strong, nonatomic) IBOutlet UIView *convictionView;
@property (strong, nonatomic) IBOutlet UIView *notesView;


+(NavigationPopoverView*)navigationView;

@end

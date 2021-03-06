//
//  HomeViewController.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/12/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "NavigationPopoverView.h"

@interface HomeViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate> {
    
    IBOutlet UIImageView *compassionImage;
    IBOutlet UIImageView *convictionImage;
    IBOutlet UIImageView *passionImage;
    IBOutlet UIImageView *purposeImage;
    
    IBOutlet UILabel *passionCounter;
    IBOutlet UILabel *purposeCounter;
    IBOutlet UILabel *convictionCounter;
    IBOutlet UILabel *compassionCounter;
    
    IBOutlet UIImageView *passionAct;
    IBOutlet UIImageView *compassionAct;
    IBOutlet UIImageView *purposeAct;
    IBOutlet UIImageView *convictionAct;
    
    IBOutlet UIView *compassionView;
    IBOutlet UIView *convictionView;
    IBOutlet UIView *purposeView;
    IBOutlet UIView *passionView;
    
    NavigationPopoverView *_navMenu;
}

@end

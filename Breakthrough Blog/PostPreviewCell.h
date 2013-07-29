//
//  PostPreviewCell.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPreviewCell : UITableViewCell {

}

@property (strong, nonatomic) IBOutlet UILabel *drilldownTitle;
@property (strong, nonatomic) IBOutlet UIImageView *drilldownImage;
@property (strong, nonatomic) IBOutlet UILabel *drilldownExcerpt;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bannerNewIndicator;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

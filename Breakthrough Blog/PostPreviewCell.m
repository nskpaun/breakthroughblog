//
//  PostPreviewCell.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "PostPreviewCell.h"

@implementation PostPreviewCell

@synthesize drilldownTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PNIB" owner:self options:nil] objectAtIndex:0];
        if (!self.drilldownTitle) {
            NSLog(@"No title");
        }
   
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end

//
//  MenuViewCell.m
//  iOSAnimationDemo
//
//  Created by mada on 15/9/21.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "MenuViewCell.h"

@interface MenuViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation MenuViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

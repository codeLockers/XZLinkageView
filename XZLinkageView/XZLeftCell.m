//
//  XZLeftCell.m
//  XZLinkageView
//
//  Created by codeLocker on 2016/12/21.
//  Copyright © 2016年 codeLocker. All rights reserved.
//

#import "XZLeftCell.h"
#import <Masonry/Masonry.h>

@interface XZLeftCell()
@property (nonatomic, strong) UIView *yellowBlockView;
@end

@implementation XZLeftCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.yellowBlockView];
        [self.contentView addSubview:self.nameLab];
        
        [self layout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
//    self.highlighted = selected;
    self.nameLab.highlighted = selected;
    self.yellowBlockView.hidden = !selected;
}

#pragma mark - Layout
- (void)layout{

    [self.yellowBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(40);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.yellowBlockView.mas_right);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

#pragma mark - Seter && Getter
- (UIView *)yellowBlockView{

    if (!_yellowBlockView) {
        
        _yellowBlockView = [[UIView alloc] init];
        _yellowBlockView.backgroundColor = [UIColor yellowColor];
    }
    return _yellowBlockView;
}

- (UILabel *)nameLab{

    if (!_nameLab) {
        
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.font = [UIFont systemFontOfSize:15.f];
        _nameLab.numberOfLines = 0;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.highlightedTextColor = [UIColor yellowColor];
    }
    return _nameLab;
}
@end

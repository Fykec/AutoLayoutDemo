//
//  LayoutSubviewsDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "LayoutSubviewsDemoView.h"

@interface LayoutSubviewsDemoView () {

    UILabel *_centerLabel;

}

@end


@implementation LayoutSubviewsDemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _centerLabel = [UILabel new];
        _centerLabel.text = @"我是一个居中的文本";
        _centerLabel.numberOfLines = 0;
        _centerLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_centerLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];
    _centerLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - textSize.width) / 2, (CGRectGetHeight(self.bounds) - textSize.height) / 2, textSize.width, textSize.height);
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];
//    CGFloat originX = (self.bounds.size.width - textSize.width) / 2;
//    CGFloat originY = (self.bounds.size.height - textSize.height) / 2;
//    CGFloat width = textSize.width;
//    CGFloat height = textSize.height;
//    _centerLabel.frame = CGRectMake(originX, originY, width, height);
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];
//    CGFloat left = (1 / 2) * self.bounds.size.width - textSize.width / 2;
//    CGFloat top = (1 / 2) * self.bounds.size.height - textSize.height / 2;
//    CGFloat width = textSize.width;
//    CGFloat height = textSize.height;
//    _centerLabel.frame = CGRectMake(left, top, width, height);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

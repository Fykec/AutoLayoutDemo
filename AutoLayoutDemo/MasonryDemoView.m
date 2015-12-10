//
//  MasonryDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryDemoView.h"
#import "Masonry.h"

@interface MasonryDemoView () {

    UILabel *_centerLabel;

}

@end

@implementation MasonryDemoView

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


//- (void)updateConstraints {
//
//    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_centerLabel.superview);
//    }];
//
//    [super updateConstraints];
//}

- (void)updateConstraints {

    [_centerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_centerLabel.superview);
    }];

    [super updateConstraints];
}

@end

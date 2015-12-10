//
//  VFLDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "VFLDemoView.h"


@interface VFLDemoView () {

    UILabel *_centerLabel;

}

@end


@implementation VFLDemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _centerLabel = [UILabel new];
        _centerLabel.text = @"我是一个居中的文本";
        _centerLabel.numberOfLines = 0;
        _centerLabel.backgroundColor = [UIColor redColor];
        _centerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_centerLabel];


    }
    return self;
}


//Reference from: https://github.com/evgenyneu/center-vfl
- (void)updateConstraints {

    UIView *superview = self;
    NSDictionary *views = NSDictionaryOfVariableBindings(_centerLabel, superview);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[superview]-(<=1)-[_centerLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[_centerLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];

    [super updateConstraints];
}


@end

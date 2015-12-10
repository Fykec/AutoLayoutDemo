//
//  MasonryLayoutMarginsDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/9/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryLayoutMarginsDemoView.h"
#import "Masonry.h"

@interface MasonryLayoutMarginsDemoView () {

    UIView *_fistView;

    UIView *_secondView;
}

@end


@implementation MasonryLayoutMarginsDemoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fistView = [UIView new];
        _fistView.backgroundColor = [UIColor redColor];
        [self addSubview:_fistView];

        _secondView = [UIView new];
        _secondView.backgroundColor = [UIColor greenColor];
        [_fistView addSubview:_secondView];

        self.layoutMargins = UIEdgeInsetsMake(20, 20, 20, 20);
        self.preservesSuperviewLayoutMargins = YES;
    }
    return self;
}

- (void)updateConstraints {

//    [_fistView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.height.equalTo(@(100));
//    }];

    [NSLayoutConstraint constraintWithItem:_fistView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_fistView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_fistView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_fistView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];


    [NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_fistView attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_fistView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_fistView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:_secondView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_fistView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0.0];

    [super updateConstraints];
}

@end

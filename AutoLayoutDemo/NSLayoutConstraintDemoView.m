//
//  NSLayoutConstraintsDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "NSLayoutConstraintDemoView.h"

@interface NSLayoutConstraintDemoView () {

    UILabel *_centerLabel;

}

@end


@implementation NSLayoutConstraintDemoView

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


- (void)updateConstraints {


    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];

    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_centerLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_centerLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]]];
    [_centerLabel addConstraints:@[[NSLayoutConstraint constraintWithItem:_centerLabel
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0
                                                                 constant:textSize.width],
                                   [NSLayoutConstraint constraintWithItem:_centerLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0
                                                                 constant:textSize.height]]];


    [super updateConstraints];
}


@end

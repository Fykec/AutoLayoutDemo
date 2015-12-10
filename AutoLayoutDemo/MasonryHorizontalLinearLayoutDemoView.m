//
//  MasonryHorizontalLinearLayoutDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/10/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryHorizontalLinearLayoutDemoView.h"
#import "Masonry.h"

@interface MasonryHorizontalLinearLayoutDemoView () {

    NSArray *_cells;
    
}

@end


@implementation MasonryHorizontalLinearLayoutDemoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *cells = [NSMutableArray array];

        int count = 7;
        for (int i = 0; i < count; i++)
        {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed: i/10.0 green:i/10.0 blue:i/10.0 alpha:1];
            [self addSubview:view];
            [cells addObject:view];
        }
        _cells = cells;
    }
    return self;
}

- (void)updateConstraints {

    UIView *lastCell = nil;

    for (UIView *cell in _cells) {
        [cell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(20));
            make.bottom.equalTo(@(-20));
            make.width.equalTo(@(20));
            if (lastCell) {
                make.left.equalTo(lastCell.mas_right).offset(20);
            }
            else {
                make.left.equalTo(@(20));
            }
        }];

        lastCell = cell;
    }

    [super updateConstraints];
}


@end

//
//  MasonryLinearLayoutDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/9/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryLinearLayoutDemoView.h"
#import "Masonry.h"

@interface MasonryLinearLayoutDemoView () {

    NSArray *_cells;
}
@end


@implementation MasonryLinearLayoutDemoView


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
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@(40));
            if (lastCell) {
                make.top.equalTo(lastCell.mas_bottom).offset(20);
            }
            else {
                make.top.equalTo(@(20));
            }
        }];

        lastCell = cell;
    }

    [super updateConstraints];
}

@end

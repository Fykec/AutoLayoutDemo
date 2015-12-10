//
//  MasonryGridLayoutDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/9/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryGridLayoutDemoView.h"
#import "Masonry.h"

@interface MasonryGridLayoutDemoView () {

    NSArray *_cells;

}

@end


@implementation MasonryGridLayoutDemoView

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

    CGFloat cellWidth = 70;
    NSInteger countPerRow = 3;
    CGFloat gap = (self.bounds.size.width -  cellWidth * countPerRow) / (countPerRow + 1);

    NSUInteger count = _cells.count;
    for (NSUInteger i = 0; i < count; i++)
    {
        UIView *cell =  [_cells objectAtIndex:i];
        NSInteger row = i / countPerRow;
        NSInteger column = i % countPerRow;

        [cell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(row * (gap + cellWidth) + gap));
            make.left.equalTo(@(column * (gap + cellWidth) + gap));
            make.width.equalTo(@(cellWidth));
            make.height.equalTo(@(cellWidth));
        }];
    }

    [super updateConstraints];
}


@end

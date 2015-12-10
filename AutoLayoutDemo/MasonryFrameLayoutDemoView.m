//
//  MasonryFrameLayoutDemoView.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/9/15.
//  Copyright © 2015 Taijicoder. All rights reserved.
//

#import "MasonryFrameLayoutDemoView.h"
#import "Masonry.h"

@interface MasonryFrameLayoutDemoView () {

    NSArray *_cells;
    
}

@end


@implementation MasonryFrameLayoutDemoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *cells = [NSMutableArray array];

        int count = 10;
        UIView *lastCell = nil;
        for (int i = 0; i < count; i++)
        {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithRed:1 - i/10.0 green:1 - i/10.0 blue:1 - i/10.0 alpha:1];
            if (lastCell == nil) {
                [self addSubview:view];
            }
            else {
                [lastCell addSubview:view];
            }
            lastCell = view;
            [cells addObject:view];
        }
        _cells = cells;
    }
    return self;
}

- (void)updateConstraints {

    NSUInteger count = _cells.count;


    for (NSUInteger i = 0; i < count; i++)
    {
        UIView *cell =  [_cells objectAtIndex:i];

        [cell mas_makeConstraints:^(MASConstraintMaker *make) {

            switch (i % 9) {
                case 0:
                    make.center.equalTo(cell.superview);
                    break;
                case 1:
                    make.left.equalTo(cell.superview);
                    make.top.equalTo(cell.superview);
                    break;
                case 2:
                    make.left.equalTo(cell.superview);
                    make.centerY.equalTo(cell.superview);
                    break;
                case 3:
                    make.left.equalTo(cell.superview);
                    make.bottom.equalTo(cell.superview);
                    break;
                case 4:
                    make.centerX.equalTo(cell.superview);
                    make.bottom.equalTo(cell.superview);
                    break;
                case 5:
                    make.right.equalTo(cell.superview);
                    make.bottom.equalTo(cell.superview);
                    break;
                case 6:
                    make.right.equalTo(cell.superview);
                    make.centerY.equalTo(cell.superview);
                    break;
                case 7:
                    make.right.equalTo(cell.superview);
                    make.top.equalTo(cell.superview);
                    break;
                case 8:
                    make.centerX.equalTo(cell.superview);
                    make.top.equalTo(cell.superview);
                    break;

                default:
                    break;
            }


            make.width.equalTo(@(CGRectGetWidth(self.bounds)  - 30 * i));
            make.height.equalTo(@(CGRectGetHeight(self.bounds) - 30 * i));
        }];
    }

    [super updateConstraints];
}


@end

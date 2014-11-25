//
//  HeaderCellCollectionViewCell.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/16/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "HeaderCellCollectionViewCell.h"

@implementation HeaderCellCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        // Blur effect
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.bounds];
        [self addSubview:blurEffectView];
    }
    
    return self;
}


@end

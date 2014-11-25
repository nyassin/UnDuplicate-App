//
//  FullScreenImage.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/9/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "FullScreenImage.h"

@implementation FullScreenImage

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1. alpha:.5];
        
        // TODO: Add Done Button and put a target to it.
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneWithView:)];
        gestureRecognizer.delegate = self;
        gestureRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:gestureRecognizer];

        return self;
    }
    return nil;
}

- (void)doneWithView:(UITapGestureRecognizer *)gestureRecognizer
{
    [self removeFromSuperview];
}

@end

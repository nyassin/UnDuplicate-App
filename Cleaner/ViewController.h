//
//  ViewController.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/5/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRDynamicSlideshow.h"

@interface ViewController : UIViewController
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end


//
//  PhotosViewController.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/5/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureGrid.h"
#import "ControlPanel.h"
#import "TrashBin.h"

@import Photos;

@interface PhotosViewController : UIViewController <PictureGridDelegate, ControlPanelDelegate, TrashBinDelegate>

@property (strong)  NSMutableArray *results;

@property (nonatomic, strong) ControlPanel *controlPanel;

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month;

@end

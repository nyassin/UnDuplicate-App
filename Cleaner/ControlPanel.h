//
//  ControlPanel.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/16/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@protocol  ControlPanelDelegate <NSObject>

- (void)chosenDifferentMonth;
- (void)clickedTrashBin;

@end


@interface ControlPanel : UIView


@property (weak, nonatomic) id<ControlPanelDelegate> delegate;

@property (nonatomic) NSString *selectedCount;
@property (nonatomic) NSString *monthLabel;
@property (nonatomic) NSString *yearLabel;

@end

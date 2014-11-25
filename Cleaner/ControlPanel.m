//
//  ControlPanel.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/16/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "ControlPanel.h"
#import "EngineAPI.h"
#import "MBProgressHUD.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ControlPanel

\
- (id)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        // Initiate trash can button
        UIButton *trash=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage *buttonImage = [[UIImage imageNamed:@"actuallyWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        trash.frame= CGRectMake(0, 20, 40, 40);
        [trash setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [trash addTarget:self action:@selector(clickedTrash) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:trash];
        
        // Initiate selected images ticker.
        self.selectedCount = @"0";
        UILabel *selectedCounter = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 85, 32, 85, 20)];
        selectedCounter.textColor = [UIColor whiteColor];
        selectedCounter.font = [selectedCounter.font fontWithSize:13];
        [self addSubview:selectedCounter];
        
        //   Observe changes in the selected count.
        [[RACObserve(self, selectedCount) filter:^BOOL(NSString *value) {
            NSUInteger integerVal = [value integerValue];
            if (integerVal) {
                return YES;
            } else {
                selectedCounter.text = @"0 Duplicates";
                return NO;
            }
        }] subscribeNext:^(NSString *newValue) {
            NSLog(@"%@", newValue);
            selectedCounter.text = [newValue stringByAppendingString:@" Duplicates"] ;
        }];
        
        // Show name of Month in the scroller
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:([EngineAPI sharedInstance].month-1)];
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width /2, 20, 80, 30)];
        monthLabel.textColor = [UIColor whiteColor];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.text = monthName;
        monthLabel.numberOfLines = 1;
        monthLabel.adjustsFontSizeToFitWidth = YES;
        [monthLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [monthLabel setCenter:self.center];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:monthLabel];
        
        [RACObserve(self, monthLabel) subscribeNext:^(NSString *newMonth) {
            NSLog(@"%@", newMonth);
            monthLabel.text = newMonth;
        }];
        
        // Show what year it is.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *yearString = [formatter stringFromDate:[NSDate date]];
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width /2 - 15, self.bounds.size.height /2 + 10, 30, 30)];
        yearLabel.textColor = [UIColor whiteColor];
        yearLabel.backgroundColor = [UIColor clearColor];
        yearLabel.text = yearString;
        [yearLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [yearLabel sizeToFit];
        [self addSubview:yearLabel];
        
        [RACObserve(self, yearLabel) subscribeNext:^(NSString *newYear) {
            yearLabel.text = newYear;
        }];
        
        
        // Navigation buttons
        UIButton *but=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        but.frame= CGRectMake(monthLabel.frame.origin.x - 20, 30, 20, 30);
        UIImage *backImage = [[UIImage imageNamed:@"backButtonWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [but setBackgroundImage:backImage forState:UIControlStateNormal];
        [but addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
        UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        nextButton.frame= CGRectMake(monthLabel.frame.origin.x + monthLabel.frame.size.width, 30, 20, 30);
        UIImage *forwardImage = [[UIImage imageNamed:@"forwardButtonWhite.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nextButton setImage:forwardImage forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        nextButton.tag = 1;
        
        [RACObserve(self, monthLabel) subscribeNext:^(NSString *newMonth) {

            NSDate *date = [NSDate date];
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
            NSInteger month = [dateComponents month];
            NSInteger year = [dateComponents year];
            if ([EngineAPI sharedInstance].month == month && [EngineAPI sharedInstance].year == year) {
                nextButton.hidden = YES;
            } else
            {
                nextButton.hidden = NO;
            }
            
        }];
        
        [self addSubview:nextButton];
        
        self.backgroundColor = [UIColor blackColor];
        
        return self;
    }
    return nil;
}

- (void)buttonAction:(id)sender
{
    
    UIButton *buttonClicked = (UIButton *)sender;
    
    if ([buttonClicked tag] == 1) {
        
        [[EngineAPI sharedInstance] setNextMonth];
        
    } else {
        
        [[EngineAPI sharedInstance] setPreviousMonth];
    }
    
    if([self.delegate respondsToSelector:@selector(chosenDifferentMonth)]) {
        [self.delegate chosenDifferentMonth];
    }
    
}
- (void)clickedTrash
{
    if([self.delegate respondsToSelector:@selector(clickedTrashBin)]) {
        [self.delegate clickedTrashBin];
    }
}

@end

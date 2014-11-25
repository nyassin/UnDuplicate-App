//
//  EngineAPI.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;
#import "Manager.h"

@interface EngineAPI : NSObject

/**
 * An instance of the API shared accross the different views and controllers.
 */
+(EngineAPI *)sharedInstance;

/**
 * An instance of Manager class which handles all photo requests.
 */
@property (nonatomic,strong) Manager *manager;

@property NSInteger month;
@property NSInteger year;

- (void)setNextMonth;
- (void)setPreviousMonth;

-(NSMutableArray *)getImages:(NSMutableArray *)images;

-(NSMutableArray *)groupByTimeTaken:(NSMutableArray *)images;

-(NSMutableArray *)fetchSelectedImagesToDelete:(NSArray *)images forPaths:(NSArray *)paths;
@end

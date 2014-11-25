//
//  Manager.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface Manager : NSObject

@property (strong) PHCachingImageManager *imageManager;

/**
 * Takes an Array of all Images and returns only those taken in current month.
 */
-(NSMutableArray *)getImagesCreatedInAMonth:(NSMutableArray *)images forMonth:(NSInteger)month andYear:(NSInteger)year;

/**
 * Takes an image batch and returns a sorted array of dictionaries grouped by time taken.
 */
-(NSMutableArray *)groupByTimeTaken:(NSArray *)images;

/**
 * returns YES if time differeces between DateA and DateB is less than NSInteger Seconds. NO otherwise.
 */
-(BOOL)timeDifferenceLessThan:(NSInteger)seconds dateA:(NSDate *)dateA dateB:(NSDate *)dateB;

@end

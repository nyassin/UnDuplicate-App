//
//  Manager.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "Manager.h"
#define TIME_INTERVAL_BETWEEN_PICTURES 60

@import Photos;

@implementation Manager

- (NSMutableArray *)getImagesCreatedInAMonth:(NSMutableArray *)result forMonth:(NSInteger)month andYear:(NSInteger)year
{
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    for( PHAsset *asset in result)
    {
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|
                                        NSCalendarUnitMonth|
                                        NSCalendarUnitDay|
                                        NSCalendarUnitHour|
                                        NSCalendarUnitMinute|
                                        NSCalendarUnitSecond
                                                   fromDate:[asset creationDate]];
        if([components year] == year &&
           [components month] == month)
        {
            [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
                
                if(image)
                {
                    NSDictionary *metaData = @{@"image": image, @"metaData": [asset creationDate], @"asset": asset };
                    [pictures addObject:metaData];
                }
            }];
        }
    }
    return (NSMutableArray *)pictures;
}

- (NSMutableArray *)groupByTimeTaken:(NSArray *)images
{
    NSDate *dateA;
    NSDate *dateB;
    NSMutableArray *container = [NSMutableArray new];
    NSMutableArray *group = [NSMutableArray new];
    
    if(![images count]) {
        return nil;
    }
    
    for(int i=0; i < [images count] - 1; i ++)
    {
        dateA = [[images objectAtIndex:i] objectForKey:@"metaData"];
        dateB = [[images objectAtIndex:i+1] objectForKey:@"metaData"];
        
        // Group objects taken within set seconds of each other
        if([self timeDifferenceLessThan:TIME_INTERVAL_BETWEEN_PICTURES dateA:dateA dateB:dateB])
        {
            [group addObject:[images objectAtIndex:i]];
            
        } else if ([group count] > 0)
        {
            [group addObject:[images objectAtIndex:i]];
            NSMutableArray *copy = [group mutableCopy];
            [container addObject:copy];
            [group removeAllObjects];
        }
    }
    
    return container;
}

- (BOOL)timeDifferenceLessThan:(NSInteger)seconds dateA:(NSDate *)dateA dateB:(NSDate *)dateB
{
    return [dateB timeIntervalSinceDate:dateA] < (double)seconds;
}

@end

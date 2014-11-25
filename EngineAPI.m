//
//  EngineAPI.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "EngineAPI.h"
#import "Manager.h"
@implementation EngineAPI

+(EngineAPI *)sharedInstance
{
    static EngineAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[EngineAPI alloc] init];
        
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        self.manager = [[Manager alloc] init];
    }
    return self;
}

- (NSMutableArray *)fetchSelectedImagesToDelete:(NSArray *)images forPaths:(NSArray *)paths
{
    __block NSMutableArray *imagesToDelete = [NSMutableArray new];
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSIndexPath  *indexPath = (NSIndexPath *)obj;
        UIImage *image = [[[images objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"asset"];
        [imagesToDelete addObject:image];
    }];
    return imagesToDelete;
}

- (NSMutableArray *)getImages:(NSMutableArray *)results
{
    NSMutableArray *images = [self.manager getImagesCreatedInAMonth:results forMonth:self.month andYear:self.year];
    NSMutableArray *newImages = [NSMutableArray new];
    newImages = [self groupByTimeTaken:images];
    return newImages;
}

- (NSMutableArray *)groupByTimeTaken:(NSMutableArray *)images
{
    return [self.manager groupByTimeTaken:images];
}

- (void)setPreviousMonth
{
    if (self.month == 1)
    {
        self.month = 12;
        self.year--;
    } else {
        self.month--;
    }
}

- (void)setNextMonth
{
    if (self.month == 12)
    {
        self.month = 1;
        self.year++;
    } else {
        self.month++;
    }
}

@end

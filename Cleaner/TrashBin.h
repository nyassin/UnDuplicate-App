//
//  TrashBin.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/18/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;


@protocol  TrashBinDelegate <NSObject>

- (void)emptiedOffTrash;
- (void)dismissedView;
@end



@interface TrashBin : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

-(id)initWithFrame:(CGRect )frame forImages:(NSArray *)images;

@property (nonatomic,strong) NSArray *Images;
@property (nonatomic,strong) NSArray *pathsForImages;
@property (strong) PHCachingImageManager *imageManager;

@property (weak, nonatomic) id<TrashBinDelegate> delegate;


@end

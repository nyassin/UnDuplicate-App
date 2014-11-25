//
//  PictureGrid.h
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PictureGrid;

/**
 * Inform the delegate when user presses on Picture for full screen view.
 */
@protocol  PictureGridDelegate <NSObject>

- (void)pressedLongOnImage:(UIImage *)image;
- (void)updateSelectedCount:(NSUInteger)count;

@end

@interface PictureGrid : UIView <UICollectionViewDataSource,
UICollectionViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic) UICollectionView *grid;
@property (nonatomic, strong) NSMutableArray *imagesContent;
@property (nonatomic, strong) NSMutableArray *pathsForSelectedImages;
@property (weak, nonatomic) id<PictureGridDelegate> delegate;

-(id)initWithFrame:(CGRect )frame andImages:(NSArray *)images;

- (void)reloadDataWithImages:(NSMutableArray *)images;
- (void)showLoadingView;
- (void)hideLoadingView;
//- (void)removeDeletedImages;

@end



//
//  QBAssetsCollectionViewCell.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *asset;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@end

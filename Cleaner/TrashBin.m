//
//  TrashBin.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/18/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "TrashBin.h"
#import "PictureGrid.h"

static NSString *cellIdentifier = @"cvCell";


@implementation TrashBin


- (id)initWithFrame:(CGRect)frame forImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.Images = images;
        self.imageManager = [[PHCachingImageManager alloc] init];

        // Setup button layout
        UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        nextButton.frame= CGRectMake(10, 30, 25, 25);
        [nextButton setBackgroundImage:[UIImage imageNamed:@"xbutton.png"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(doneWithTrash) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        self.backgroundColor = [UIColor whiteColor];
        
        // If there are no selected pictures, show alert.
        if (![images count])
        {
            UILabel *nothingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.bounds.size.width, 100)];
            NSString *text =@"Swipe to select pictures first.";
            nothingLabel.text = text;
            [nothingLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
            nothingLabel.textColor = [UIColor grayColor];
            [self addSubview:nothingLabel];
            
        } else {
            
            // Setup Delete Button
            UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame= CGRectMake(0, self.bounds.size.height - 60, self.frame.size.width, 60);
            [deleteButton setBackgroundColor:[UIColor redColor]];
            [deleteButton setTitle:@"Delete Images" forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(confirmedDeletion) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:deleteButton];
                

            // Setup UICollectionViewGrid
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            [flowLayout setItemSize:CGSizeMake(104 , 104)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            UICollectionView *deletedGrid = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height - 60 -80) collectionViewLayout: flowLayout];
            deletedGrid.backgroundColor = [UIColor whiteColor];
            deletedGrid.delegate = self;
            deletedGrid.dataSource = self;

            UINib *cellNib = [UINib nibWithNibName:@"Cell" bundle:nil];
            [deletedGrid registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
            
            [self addSubview:deletedGrid];
        }
        return self;
    }
    return nil;
}

- (void)doneWithTrash
{

    [self.delegate dismissedView];
    
}

- (void)confirmedDeletion
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:self.Images];
        
    } completionHandler:^(BOOL success, NSError *error)
    {
        if(success)
        {
            // TODO: Close this app and reload images.
            self.Images = nil;
            
            if([self.delegate respondsToSelector:@selector(emptiedOffTrash)]) {
                [self.delegate emptiedOffTrash];
//                [self performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
            }
        }
    }];


}

#pragma mark - UICollectionViewDelegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.Images count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __block UIImage *imageFiller = [UIImage new];
    [self.imageManager requestImageForAsset:[self.Images objectAtIndex:indexPath.row] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        
        if(image)
        {
            imageFiller = image;
        }
        
    }];
    
    [backgroundImageView setImage:imageFiller];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell setBackgroundView:backgroundImageView];
    
    return cell;
}

@end

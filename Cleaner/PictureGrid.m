//
//  PictureGrid.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/7/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "PictureGrid.h"
#import "PDKTStickySectionHeadersCollectionViewLayout.h"
#import "HeaderCellCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "SECollectionViewFlowLayout.h"
#import "QBAssetsCollectionOverlayView.h"
#import "QBAssetsCollectionViewCell.h"


@implementation PictureGrid
@import Photos;

static NSString *cellIdentifier = @"cvCell";
static NSString *headerIdentifier = @"CollectionViewImageHeader";

- (id)initWithFrame:(CGRect )frame andImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imagesContent = images;
        self.pathsForSelectedImages = [NSMutableArray new];
        
        SECollectionViewFlowLayout *flowLayout = [SECollectionViewFlowLayout layoutWithAutoSelectRows:YES panToDeselect:YES autoSelectCellsBetweenTouches:NO];
        [flowLayout setItemSize:CGSizeMake(104, 104)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 25);
        
        self.grid = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height ) collectionViewLayout:flowLayout];
        
        [self.grid registerClass:[HeaderCellCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        [self.grid registerClass:[QBAssetsCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        // Add Gesture Recognition
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        gestureRecognizer.minimumPressDuration = .7;
        gestureRecognizer.delegate = self;
        gestureRecognizer.delaysTouchesBegan = YES;
        [self.grid addGestureRecognizer:gestureRecognizer];
        
        self.grid.backgroundColor = [UIColor whiteColor];
        self.grid.allowsMultipleSelection = YES;
        self.grid.delegate = self;
        self.grid.dataSource = self;
        
        
        [self addSubview:self.grid];
        
        return self;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.imagesContent count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *similarPictures = [self.imagesContent objectAtIndex:section];
    return [similarPictures count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.showsOverlayViewWhenSelected = self.grid.allowsMultipleSelection;
    
    cell.asset = [[[self.imagesContent objectAtIndex:indexPath.section]
                   objectAtIndex:indexPath.row] objectForKey:@"image"];
    
    cell.selected = NO;
    if([self.pathsForSelectedImages containsObject:indexPath]) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pathsForSelectedImages removeObject:indexPath];
    if([self.delegate respondsToSelector:@selector(updateSelectedCount:)]) {
        [self.delegate updateSelectedCount:[self.pathsForSelectedImages count]];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pathsForSelectedImages addObject:indexPath];
    
    // TODO: Send notification to Control Panel and update count.
    if([self.delegate respondsToSelector:@selector(updateSelectedCount:)]) {
        [self.delegate updateSelectedCount:[self.pathsForSelectedImages count]];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged ||
       gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint p = [gestureRecognizer locationInView:self.grid];
    NSIndexPath *indexPath = [self.grid indexPathForItemAtPoint:p];
    
    if(indexPath)
    {
        UIImage *image = [[[self.imagesContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"];
        
        if([self.delegate respondsToSelector:@selector(pressedLongOnImage:)]) {
            [self.delegate pressedLongOnImage:image];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderCellCollectionViewCell * cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        if(![[self.imagesContent objectAtIndex:indexPath.section] isKindOfClass:[NSNull class]])
        {
            NSArray *data = [self.imagesContent objectAtIndex:indexPath.section];
            cell = [self formatSectionHeader:cell withData:data];
            
        }
        return cell;
    }
    
    return nil;
}

- (void)reloadDataWithImages:(NSMutableArray *)images
{
    
    [self.pathsForSelectedImages removeAllObjects];
    self.imagesContent = images;
    

    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        [self.grid reloadData];
    });

    
}

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)hideLoadingView {
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    
}

- (HeaderCellCollectionViewCell *)formatSectionHeader:(HeaderCellCollectionViewCell *)cell withData:(NSArray *)data
{
    
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    UILabel * titleHeader = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width, 15)];
    titleHeader.backgroundColor = [UIColor clearColor];
    titleHeader.textColor = [UIColor blackColor];
    titleHeader.text = [dateFormatter stringFromDate:[[data firstObject] objectForKey:@"metaData"]];
    [titleHeader setFont:[UIFont systemFontOfSize:12.0f]];
    [titleHeader sizeToFit];
    
    // Hackish coding here. Change when you have a chance.
    if ([[[cell subviews] lastObject] isKindOfClass:[UILabel class]]) {
        UILabel *existingLabel = [[cell subviews] lastObject];
        existingLabel.text = [dateFormatter stringFromDate:[[data firstObject] objectForKey:@"metaData"]];
        
    } else {
        [cell addSubview:titleHeader];
    }
    return cell;
}
@end


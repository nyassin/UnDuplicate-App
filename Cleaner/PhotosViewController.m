//
//  PhotosViewController.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/5/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "PhotosViewController.h"
#import "EngineAPI.h"
#import "PictureGrid.h"
#import "FullScreenImage.h"
#import "ControlPanel.h"
#import "MBProgressHUD.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController {
    NSMutableArray *images;
    PictureGrid *grid;
}

- (NSMutableArray *)updateImageResults
{
    NSMutableArray *totalResults = [NSMutableArray new];
    PHFetchResult *fetchResults = [PHAssetCollection fetchMomentsWithOptions:nil];
    for (PHAssetCollection *moments in fetchResults)
    {
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:moments
                                                                          options:nil];
        for (PHAsset *asset in assetsFetchResults) {
            [totalResults addObject:asset];
        }
    }
 
    return totalResults;
}

- (void)finishSetup
{
 
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    [EngineAPI sharedInstance].year = year;
    [EngineAPI sharedInstance].month = month;
    
    images = [[EngineAPI sharedInstance] getImages:_results];
    
    grid = [[PictureGrid alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80) andImages:images];
    grid.delegate = self;
    
    self.controlPanel = [[ControlPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.controlPanel.delegate = self;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:([EngineAPI sharedInstance].month-1)];
    self.controlPanel.yearLabel = @"2014";
    self.controlPanel.monthLabel = monthName;
    
    [self.view addSubview:self.controlPanel];
    [self.view addSubview:grid];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Fetching Duplicate Pictures";
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                _results = [self updateImageResults];
                [self performSelectorOnMainThread:@selector(finishSetup) withObject:nil waitUntilDone:NO];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                break;
            case PHAuthorizationStatusRestricted:
                break;
            case PHAuthorizationStatusDenied:
                break;
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TrashBinDelegate

- (void)emptiedOffTrash
{
    NSArray *pathsCopy = [grid.pathsForSelectedImages copy];
    
    // Update the view of the grid on the Main Thread to show changes immediately.
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        for (NSIndexPath *indexPath in pathsCopy)
        {
            if ([grid.imagesContent objectAtIndex:indexPath.section] && [[grid.imagesContent objectAtIndex:indexPath.section] count] > indexPath.row)
            {
                if ([[grid.imagesContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]) {
                    [grid.grid deselectItemAtIndexPath:indexPath animated:YES];
                    [grid.pathsForSelectedImages removeObject:indexPath];
                    [[grid.imagesContent objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
                }
            }
        }

        [grid reloadDataWithImages:grid.imagesContent];
        [self dismissViewControllerAnimated:YES completion:^{}];
        self.controlPanel.selectedCount = @"";

    });

}

- (void)dismissedView
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - PictureGridDelegates

- (void)pressedLongOnImage:(UIImage *)image
{
    FullScreenImage *fullScreenView = [[FullScreenImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andImage:image] ;
    [self.view addSubview:fullScreenView];
}

- (void)updateSelectedCount:(NSUInteger)count
{
    self.controlPanel.selectedCount = [NSString stringWithFormat:@"%zd", count];
}

#pragma mark - ControlPanelDelegates

- (void)chosenDifferentMonth
{
    NSDate *dateDesired = [self dateWithYear:[EngineAPI sharedInstance].year month:[EngineAPI sharedInstance].month];
    
    NSTimeInterval timeDiff = [dateDesired timeIntervalSinceNow];
    if (timeDiff > 0) {
        [[EngineAPI sharedInstance] setPreviousMonth];
        
    } else
    {
        [grid performSelectorInBackground:@selector(showLoadingView) withObject:nil];
        
        // Reload data for GridView and empty array of chosen images.
        images = [[EngineAPI sharedInstance] getImages:_results];
        [grid reloadDataWithImages:images];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:([EngineAPI sharedInstance].month-1)];
        
        self.controlPanel.monthLabel = monthName;
        self.controlPanel.yearLabel = [NSString stringWithFormat:@"%zd",[EngineAPI sharedInstance].year];
        self.controlPanel.selectedCount = @"";
        
        [grid performSelectorInBackground:@selector(hideLoadingView) withObject:nil];
    }
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month
{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    return [calendar dateFromComponents:components];
}

- (void)clickedTrashBin
{
    NSArray *imagesToDelete = [[EngineAPI sharedInstance] fetchSelectedImagesToDelete:grid.imagesContent
                                                                             forPaths:grid.pathsForSelectedImages];
    
    TrashBin *trashBinView = [[TrashBin alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) forImages:imagesToDelete];
    trashBinView.delegate = self;
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc.view addSubview:trashBinView];
    
    [self presentViewController:vc animated:YES completion:^{}];
    
}

@end

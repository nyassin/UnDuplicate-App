//
//  ViewController.m
//  Cleaner
//
//  Created by Nuseir Yassin on 10/5/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "ViewController.h"
#import "PhotosViewController.h"
#import "MBProgressHUD.h"

@import Photos;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    UIImage *image4;
    
    image1 = [UIImage imageNamed:@"singularityWalk1.png"];
    image2 = [UIImage imageNamed:@"singularityWalk2.png"];
    image3 = [UIImage imageNamed:@"singularityWalk3.png"];
    image4 = [UIImage imageNamed:@"newWalkthrough4.png"];
    
    NSArray *pictures = [NSArray arrayWithObjects:image1, image2, image3, image4, nil];
    for (int i = 0; i < pictures.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [pictures objectAtIndex:i];
        
        if (i == (pictures.count - 1))
        {
            // Get Started Button
            UIButton *getStarted = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            getStarted.backgroundColor = [UIColor clearColor];
            getStarted.tintColor = [UIColor whiteColor];
            [getStarted setTitle:@"Fetch Pictures!" forState:UIControlStateNormal];
            [getStarted addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            //Configure UIView
            UIView *viewFrame = [[UIView alloc] initWithFrame:frame];
            subview.frame = viewFrame.bounds;
            getStarted.frame = CGRectMake(0, viewFrame.frame.size.height - 150, viewFrame.frame.size.width, 150);
            viewFrame.userInteractionEnabled = YES;
            subview.userInteractionEnabled = YES;
            
            [viewFrame addSubview:subview];
            [viewFrame addSubview:getStarted];
            [viewFrame bringSubviewToFront:getStarted];
            
            [self.scrollView addSubview:viewFrame];

        } else {
            [self.scrollView addSubview:subview];
        }

    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width
                                             * pictures.count, self.scrollView.frame.size.height);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    
}

- (void)buttonClicked
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [self performSegueWithIdentifier:@"Start" sender:nil];
}

-(void)changePageControl
{
    CGRect frame;
    
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2)
                     / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)addLoadingBar {
    [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [self performSelectorOnMainThread:@selector(addLoadingBar) withObject:nil waitUntilDone:YES];
    
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
    
    PhotosViewController *vc = segue.destinationViewController;
    vc.results = (NSMutableArray*)totalResults;

    [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
}


@end


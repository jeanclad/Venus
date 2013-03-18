//
//  VenusAlbumPageViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface VenusAlbumPageViewController : UIViewController <UIPageViewControllerDataSource>{
    UIPageViewController* _mPageViewController;
    int _mCurrentPage;
    int _mMaxPage;
    UINavigationController *rootNaviController;
    BOOL    currentNavBarHidden;
    ContentViewController *initialViewController;
    ContentViewController *contentViewController;
    NSMutableArray *mReverseKey;
}

@property (nonatomic, strong) UIPageViewController* mPageViewController;
@property (nonatomic) int mCurrentPage;
@property (nonatomic) int mMaxPage;
@property (nonatomic, strong) UINavigationController *rootNaviController;

@end

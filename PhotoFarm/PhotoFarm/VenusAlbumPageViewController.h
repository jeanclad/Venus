//
//  VenusAlbumPageViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

typedef enum {
    DIRECT_FORWARD,
    DIRECT_BACKWARD,
}_direction;


@interface VenusAlbumPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>{
    UIPageViewController* _mPageViewController;
    int _mCurrentPage;
    int _mMaxPage;
    UINavigationController *rootNaviController;
    BOOL    currentNavBarHidden;
    ContentViewController *initialViewController;
    ContentViewController *contentViewController;
    //---   test by hkkwon
    //NSMutableArray  *contentArray;
    NSMutableArray *mReverseKey;
    UIBarButtonItem *barButtonItem;
    NSUInteger pageDirect;
    BOOL pageIsAnimating;
}
@property (nonatomic, strong) UIPageViewController* mPageViewController;
@property (nonatomic) int mCurrentPage;
@property (nonatomic) int mMaxPage;
@property (nonatomic) BOOL    afterDeveloping;
@property (nonatomic, strong) UINavigationController *rootNaviController;

@end

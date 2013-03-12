//
//  VenusAlbumPageViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenusAlbumPageViewController : UIViewController <UIPageViewControllerDataSource>{
    UIPageViewController* _mPageViewController;
    int _mCurrentPage;
    int _mMaxPage;
}

@property (strong, nonatomic) UIPageViewController* mPageViewController;
@property (nonatomic) int mCurrentPage;
@property (nonatomic) int mMaxPage;

@end

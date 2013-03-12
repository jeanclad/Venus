//
//  VenusAlbumPageViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusAlbumPageViewController.h"
#import "ContentViewController.h"
#import "VenusMainViewController.h"
#import "GlobalDataManager.h"

@interface VenusAlbumPageViewController ()
// 굳이 외부로 노출 시킬 필요가 없는 함수 (Private 함수) 선언
- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index;
@end

@implementation VenusAlbumPageViewController
@synthesize mPageViewController = _mPageViewController;
@synthesize mCurrentPage = _mCurrentPage;
@synthesize mMaxPage = _mMaxPage;
@synthesize rootNaviController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mCurrentPage = 0;
    self.mMaxPage = 10;
    
    // Page Option 설정.
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // Page View Controller 생성.
    self.mPageViewController = [[UIPageViewController alloc]
                                initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                options: options];
    
    self.mPageViewController.dataSource = self;
    self.mPageViewController.view.frame = self.view.bounds;
    
    initialViewController =
    [self viewControllerAtIndex:self.mCurrentPage];
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    //  제스쳐 설정 (페이지뷰 컨틀로러가 좌/우측 탭만 하여도 넘어가기 때문에 텝 이벤트를 오버라이딩하여
    //  네비게이션 바를 숨기고 보이는 용도로 사용함
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onSingleTap:)];
    [self.mPageViewController.view addGestureRecognizer:singleTap];
    
    currentNavBarHidden = NO;
    
    [self.mPageViewController setViewControllers:viewControllers
                                       direction:UIPageViewControllerNavigationDirectionForward
                                        animated:NO
                                      completion:nil];
    [self addChildViewController:self.mPageViewController];
    [self.view addSubview:self.mPageViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -jeanclad
// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    contentViewController.mContentString =[NSString stringWithFormat:@"Page %d",index];
    return contentViewController;
}

// UIPageViewController Delegate 함수들.
- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    if (self.mCurrentPage == 0) {
        return nil;
    }
 
    self.mCurrentPage--;
    return [self viewControllerAtIndex:self.mCurrentPage];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.mCurrentPage >= self.mMaxPage -1) {
        return nil;
    }

    self.mCurrentPage++;
    return [self viewControllerAtIndex:self.mCurrentPage];
}

#pragma jeanclad
- (void) onSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizer: %d",gestureRecognizer.view.tag);
    if (currentNavBarHidden == NO){
        NSLog(@"aaa");
        [initialViewController.mContentBottomToolBar setHidden:YES];
        [contentViewController.mContentBottomToolBar setHidden:YES];
        [GlobalDataManager sharedGlobalDataManager].albumBottomToolBarHidden = YES;
        
        [self.rootNaviController setNavigationBarHidden:YES animated:YES];
        currentNavBarHidden = YES;
        

    
    }else{
        NSLog(@"bbbb");
        [initialViewController.mContentBottomToolBar setHidden:NO];
        [contentViewController.mContentBottomToolBar setHidden:NO];
        [GlobalDataManager sharedGlobalDataManager].albumBottomToolBarHidden = NO;
        
        [self.rootNaviController setNavigationBarHidden:NO animated:YES];
        currentNavBarHidden = NO;
    }
}
@end

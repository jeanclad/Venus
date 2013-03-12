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

@interface VenusAlbumPageViewController ()
// 굳이 외부로 노출 시킬 필요가 없는 함수 (Private 함수) 선언
- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index;
@end

@implementation VenusAlbumPageViewController
@synthesize mPageViewController = _mPageViewController;
@synthesize mCurrentPage = _mCurrentPage;
@synthesize mMaxPage = _mMaxPage;


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
    
    
    ContentViewController *initialViewController =
    [self viewControllerAtIndex:self.mCurrentPage];
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    [self.mPageViewController setViewControllers:viewControllers
                                       direction:UIPageViewControllerNavigationDirectionForward
                                        animated:NO
                                      completion:nil];
    
    [self addChildViewController:self.mPageViewController];
    [self.view addSubview:self.mPageViewController.view];
    [self.mPageViewController didMoveToParentViewController:self];
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
    ContentViewController* contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    contentViewController.mContentString =[NSString stringWithFormat:@"Page %d",index];
    return contentViewController;
}

// UIPageViewController Delegate 함수들.
- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    NSLog(@"dddd");
    if (self.mCurrentPage == 0) {
        return nil;
    }
    self.mCurrentPage--;
    return [self viewControllerAtIndex:self.mCurrentPage];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"cccc");
    if (self.mCurrentPage >= self.mMaxPage -1) {
        return nil;
    }
    self.mCurrentPage++;
    return [self viewControllerAtIndex:self.mCurrentPage];
}

-(void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    NSLog(@"aaaaa");
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"bbbb");
}
@end

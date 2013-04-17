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
#import "VenusAlbumDetailViewController.h"
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
        _afterDeveloping = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
    if (self.loadPlistFile == YES){
        self.mCurrentPage = 0;
        self.mMaxPage = photoInfoList.persistList.count + 1;
    } else{
        self.mCurrentPage = 0;
        self.mMaxPage = photoInfoList.persistList.count + 1;
    }
     */
    NSLog(@"plist = %@", [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList]);
    self.mCurrentPage = 0;
    self.mMaxPage = [GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList.count + 1;
    
    // Detail View에서 Page View 로 돌아왔을때 key 값이 다르면 사진이 삭제되었다고 판단한다.
    mReverseKey = [[NSMutableArray alloc] initWithArray:[GlobalDataManager sharedGlobalDataManager].reversePlistKeys];

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
    self.mPageViewController.delegate = self;
    self.mPageViewController.view.frame = self.view.bounds;
    
    initialViewController = [self viewControllerAtIndex:self.mCurrentPage];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    
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
    
    barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Detail" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = nil;
    
    //---   사진 인화후에 앨범뷰로 넘어 왔을시에는 자동으로 앨범페이지를 한장 넘겨준다.
    if (_afterDeveloping == YES){
        [self performSelector:@selector(viewAlbumPageAfterDeveloping) withObject:self afterDelay:0.5f];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[%s] persist = %@", __FUNCTION__, [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList]);
    
    if (![mReverseKey isEqualToArray:[GlobalDataManager sharedGlobalDataManager].reversePlistKeys]){
        NSLog(@"key is not equal");
        self.mMaxPage = [GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList.count + 1;
        mReverseKey = [[NSMutableArray alloc] initWithArray:[GlobalDataManager sharedGlobalDataManager].reversePlistKeys];
        [mReverseKey setArray:[GlobalDataManager sharedGlobalDataManager].reversePlistKeys];
        NSLog(@"mReverseKey = %@", mReverseKey);
    
        [contentViewController contentPhotoAnimatingAfterDelete];
        [self performSelector:@selector(viewUpdateAfterDelete) withObject:self afterDelay:1.5f];
    }

    //[self startNaviThread];
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
    NSLog(@"index = %d, reversePlistKeys = %@, mCurrentPage = %d", index, [GlobalDataManager sharedGlobalDataManager].reversePlistKeys, self.mCurrentPage);
    contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    contentViewController.mContentString =[NSString stringWithFormat:@"Page %d",index];
    //NSLog(@"content = %@", [[self.photoInfoList persistList] objectForKey:@"Venus1"]);
    
    //---   앨범 표지의 다음 페이지부터는 해당 plist data를 contentviewcontroller에게 넘긴다.
    if (index != 0){
        if (index == 1){
            [contentViewController setAfterDeveloping:_afterDeveloping];
            _afterDeveloping = NO;
        }

        contentViewController.currentPagePlistData = [[NSMutableArray alloc] initWithArray:[[[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList] objectForKey:[[GlobalDataManager sharedGlobalDataManager].reversePlistKeys objectAtIndex:self.mCurrentPage-1]]];
        
        NSLog(@"self.plist = %@", contentViewController.currentPagePlistData);
    }
    //---------------------------------------------------------------------------------------------
    
    if (self.mCurrentPage != 0)
        self.navigationItem.rightBarButtonItem = barButtonItem;
    else
        self.navigationItem.rightBarButtonItem = nil;
    
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{

}

#pragma jeanclad
- (void) onSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizer: %d",gestureRecognizer.view.tag);
    if (currentNavBarHidden == NO){
        [self.rootNaviController setNavigationBarHidden:YES animated:YES];
        currentNavBarHidden = YES;
    }else{
        [self.rootNaviController setNavigationBarHidden:NO animated:YES];
        currentNavBarHidden = NO;
    }
}

- (void) rightBarButtonPressed:(id)sender
{    
    VenusAlbumDetailViewController *venusAlbumDetailView = [[VenusAlbumDetailViewController alloc] initWithNibName:@"VenusAlbumDetailViewController" bundle:nil];
    
    NSString *selectedKey = [[GlobalDataManager sharedGlobalDataManager].reversePlistKeys objectAtIndex:self.mCurrentPage-1];
    [venusAlbumDetailView setSelectedKey:selectedKey];
    //NSLog(@"self.plist = %@", contentViewController.currentPagePlistData);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:venusAlbumDetailView animated:NO];

    // 네비게이션 스택 Push에 transition animation
    [UIView beginAnimations:@"anotheranimation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view
                             cache:NO];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
}

#pragma jecnclad
- (void)viewUpdateAfterDelete
{    
    self.mCurrentPage = self.mCurrentPage - 1;
    initialViewController = [self viewControllerAtIndex:self.mCurrentPage];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.mPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    NSLog(@"mcurrenpage = %d", self.mCurrentPage);
}

- (void)viewAlbumPageAfterDeveloping
{
    self.mCurrentPage = 1;
    initialViewController = [self viewControllerAtIndex:1];
    
    [self.mPageViewController setViewControllers:[NSArray arrayWithObject:initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
@end
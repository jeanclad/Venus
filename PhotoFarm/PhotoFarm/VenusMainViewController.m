//
//  VenusMainViewController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VenusMainViewController.h"
#import "GlobalDataManager.h"
#import "VenusFilmGroupViewController.h"
#import "VenusAlbumPageViewController.h"
#import "VenusSelectDetailViewController.h"
#import "chemicalAnimation.h"
/* persist test by jeanclad
 #import "VenusPersistList.h"
 */

//---   Float Pointing Compare Macro
#define float_epsilon 0.00001
#define float_equal(a,b) (fabs((a) - (b)) < float_epsilon)

@interface VenusMainViewController ()

@end

@implementation VenusMainViewController
@synthesize asset;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationItem.title = @"main";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float w,h;
    
    if (screen.bounds.size.height== 568) {
        w = 568;
        h = 320;
        myDevice = MYDEVICE_IPHONE5;
    }else{
        w = 480;
        h = 320;
        myDevice = MYDEVICE_ETC;
    }
    
    //--- Will Edtt position
    //---   용지 선택 뷰
    paperScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 240, 290)];
	paperContentView = [[UIView alloc] initWithFrame:CGRectMake(70, 90, 240, 2030)];
    int paperTotal = 0;
    
    for (int i = 0; i < 7; i++) {
		CGRect imageViewFrame;
		imageViewFrame = CGRectMake(0, paperTotal, 90, 100);
		paperTotal = paperTotal + 290;
		UIImageView *paperImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		UIImage *image = [UIImage imageNamed:
						  [NSString stringWithFormat:@"select_box%d.png", i]];
        paperImageView.image = image;
		[paperContentView addSubview:paperImageView];
	}
	
	[paperScrollView addSubview:paperContentView];
	paperScrollView.contentSize = paperContentView.frame.size;
	[self.selectView addSubview:paperScrollView];
	paperScrollView.pagingEnabled = YES;;
    paperScrollView.showsHorizontalScrollIndicator = NO;
    paperScrollView.showsVerticalScrollIndicator = NO;
	
	paperPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(1000, 1000, 80, 36)];
	paperPageControl.currentPage = 0;
	paperPageControl.numberOfPages = 7;
	[paperPageControl addTarget:self action:@selector(paperPageChangeValue:) forControlEvents:UIControlEventValueChanged];
	[self.selectView addSubview:paperPageControl];
	paperScrollView.delegate = self;
    
    
    //--- 용액 선택 뷰
    chemicalScrollView = [[VenusScroll alloc] initWithFrame:CGRectMake(0, 0, 240, 290)];
	chemicalContentView = [[UIView alloc] initWithFrame:CGRectMake(65, 90, 240, 2610)];
    int chemicalTotal = 0;
    
    chemicalImageView = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 9; i++) {
		CGRect imageViewFrame;
		imageViewFrame = CGRectMake(0, chemicalTotal, 50, 100);
		chemicalTotal = chemicalTotal + 290;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		UIImage *image = [UIImage imageNamed:
						  [NSString stringWithFormat:@"select_solution0%d.png", (i+1)]];
        imageView.image = image;
        [chemicalImageView addObject:imageView];
		[chemicalContentView addSubview:[chemicalImageView objectAtIndex:i]];
	}
    
    [chemicalScrollView addSubview:chemicalContentView];
	chemicalScrollView.contentSize = chemicalContentView.frame.size;
	[self.selectView addSubview:chemicalScrollView];
	chemicalScrollView.pagingEnabled = YES;;
    chemicalScrollView.showsHorizontalScrollIndicator = NO;
    chemicalScrollView.showsVerticalScrollIndicator = NO;
	
	chemicalPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(1000, 1000, 80, 36)];
	chemicalPageControl.currentPage = 0;
	chemicalPageControl.numberOfPages = 9;
	[chemicalPageControl addTarget:self action:@selector(chemicalPageChangeValue:) forControlEvents:UIControlEventValueChanged];
	[self.selectView addSubview:chemicalPageControl];
	chemicalScrollView.delegate = self;
    
    //---   비이커를 UIProgressView Custom으로 처리
    beakerView = [[VenusProgressViewController alloc] initWithFrame:CGRectMake(130, 110, 50, 80)];
    [self.selectView addSubview:beakerView];
    
    [self.navigationController.navigationBar setHidden:YES];
    MainVIewMoved = NO;
    developing = NO;
    
    //---   MainSecondView 숨기기
    [self.MainSecondView setHidden:YES];
    
    //---   용액 애니메이션 관리 Class 초기화
    if (chemicalAni == nil){
        chemicalAni = [[chemicalAnimation alloc] init];
        chemicalAni.chemicalAnimating = NO;
    }
    
    //---   PaperPreviewImage 초기화
    if (paperPreviewImageView == nil){
        CGRect imageViewFrame;
        imageViewFrame = CGRectMake(SELECT_BUTTON_MOVE_X_IP4, SELECT_BUTTON_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
        paperPreviewImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        [self.MainView addSubview:paperPreviewImageView];
    }
    
    //---   암실 트레이 이미지 설정
    CGRect imageViewFrame;
    imageViewFrame = CGRectMake(0, 10, 240, 300);
    darkRoomOffSteelImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    UIImage *image = [UIImage imageNamed:@"steel_big_off_ip4.png"];
    darkRoomOffSteelImageView.image = image;
    [self.MainSecondView addSubview:darkRoomOffSteelImageView];
    
    imageViewFrame = CGRectMake(0, 10, 480, 300);
    darkRoomOnSteelImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    image = [UIImage imageNamed:@"steel_big_on_ip4.png"];
    darkRoomOnSteelImageView.image = image;
    [self.MainSecondView addSubview:darkRoomOnSteelImageView];
    [darkRoomOnSteelImageView setHidden:YES];
    
    //---   트레이의 용액 채워지는 애니메이션 이미지 초기화
    imageViewFrame = CGRectMake(30, 40, 480-60, 320-70);
    waterImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    image = [UIImage imageNamed:@"02_water_ip4.png"];
    waterImageView.image = image;
    [self.MainView addSubview:waterImageView];
    [waterImageView setAlpha:0];
    
    imageViewFrame = CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
    developingPhotoImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [developingPhotoImageView setAlpha:0.0];
        
    [self.MainSecondView addSubview:developingPhotoImageView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float w,h;
    static ALAsset *oldAsset;
    
    if (screen.bounds.size.height== 568) {
        w = 568;
        h = 320;
    }else{
        w = 480;
        h = 320;
    }
    
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    
    [self loadPlistFile];
    
    // Will Edit to button position
    [self setAsset:(ALAsset *)[GlobalDataManager sharedGlobalDataManager].selectedAssets];
    
    NSLog(@"aaa");
    if ((asset != nil) || (firstSelect == YES)){
        NSLog(@"bbb");
        UIImage *result_img = nil;
        if (asset != nil){
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            
            UIImage *orgPhotoView = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
            
            mainPhotoView = [self makeThumbnailImage:orgPhotoView onlyCrop:NO Size:PREVIEW_FRAME_SIZE_HEIGHT];
            
            if (asset != oldAsset){
                if (_bg != nil){
                    oldAsset = asset;
                } else{
                    _bg = nil;
                    oldAsset = asset;
                }
            }
        }
        
        /*  용지가 선택되어 있는 상태에서 사진을 변경하여 선택하였을 경우와 용지를 아무것도 선택하지 않았을경우
         그 사진에 paper_preview_1 용지를 입혀야 한다.  */
        [self setPaperPreviewImage];
        result_img = preview_img;
        
        selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectedButton setBackgroundImage:result_img forState:UIControlStateNormal];
        
        if (MainVIewMoved == NO)
            selectedButton.frame = CGRectMake(w/2-70, h/2-90, PREVIEW_NO_MOVE_FRAME_SIZE_WIDTH, PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT);
        else
            //selectedButton.frame = CGRectMake((w/2-90) + moveXpos - 50, (h/2-90) + SELECT_RIGHT_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
            selectedButton.frame = CGRectMake(SELECT_BUTTON_MOVE_X_IP4, SELECT_BUTTON_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
        
        
        [selectedButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.MainView addSubview:selectedButton];
        firstSelect = YES;
        
        /*/ Photo Save to caches test by jenaclad
        NSLog(@"asset = %@", asset);
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * cachesDirectory = [paths objectAtIndex:0];
        NSString * filePath = [cachesDirectory stringByAppendingPathComponent:@"Venus_Paper_2.png"];
        UIImage * image = fullScreenImage;
        NSData * saveImageData = UIImagePNGRepresentation(image);
        [saveImageData writeToFile:filePath atomically:NO];
        NSLog(@"1 save path = %@", filePath);
        
        
        filePath = [cachesDirectory stringByAppendingPathComponent:@"Venus_Paperless_2.png"];
        UIImage * image2 = fullScreenImage;
        NSData * saveImageData2 = UIImagePNGRepresentation(image2);
        [saveImageData2 writeToFile:filePath atomically:NO];
        NSLog(@"2 save path = %@", filePath);

        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPhotoItemName:@"Venus1"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperPhotoFileName:@"Venus_Paper1.png"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperlessPhotoFileName:@"Venus_Paperless_1.png"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperType:PAPER_TYPE_CRUMPLED];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setChemicalType:[NSMutableArray arrayWithObjects:CHEMICAL_TYPE_1620, @"\n", CHEMICAL_TYPE_CYAN, @"\n", CHEMICAL_TYPE_DEVELOP_PINK, @"\n", CHEMICAL_TYPE_SPECIAL, nil]];
        
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList fillPlistData];
        
        
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPhotoItemName:@"Venus2"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperPhotoFileName:@"Venus_Paper_2.png"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperlessPhotoFileName:@"Venus_Paperless_2.png"];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperType:PAPER_TYPE_FOLDED];
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setChemicalType:[NSMutableArray arrayWithObjects:CHEMICAL_TYPE_DEVELOP_GREEN, @"\n", CHEMICAL_TYPE_VALENTINE, @"\n", CHEMICAL_TYPE_YELLO, @"\n", CHEMICAL_TYPE_GLOOM,  @"\n",CHEMICAL_TYPE_DEVELOP_GREEN, nil]];
        
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList fillPlistData];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                     initForWritingWithMutableData:data];
        [archiver encodeObject:[GlobalDataManager sharedGlobalDataManager].photoInfoFileList forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
        
        NSLog(@"persistList_load = %@", [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList]);
        
        // persist test by jeanclad
        [self loadPlistFile];
        //*/
        
    } else {
        NSLog(@"ccc");
        selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (MainVIewMoved == NO) {
            selectedButton.frame = CGRectMake(w/2-100, h/2-38, 200, 76);
        }else{
            selectedButton.frame = CGRectMake((w/2-100) + moveXpos, (h/2-38) - SELECT_RIGHT_MOVE_Y, 200, 76);
        }
        [selectedButton setTitle:@"Select to image" forState:UIControlStateNormal];
        [selectedButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.MainView addSubview:selectedButton];
        
        /* Photo load to caches test by jeanclad
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
         NSString * documentsDirectory = [paths objectAtIndex:0];
         NSString * path = [documentsDirectory stringByAppendingPathComponent:@"screenshot.png"];
         NSData * loadImageData = [NSData dataWithContentsOfFile:path];
         
         UIImage *testImage = [UIImage imageWithData:loadImageData];
         UIImageView *testImageView = [[UIImageView alloc] init];
         [testImageView setFrame:CGRectMake(0, 0, 300, 300)];
         [testImageView setImage:testImage];
         [self.view addSubview:testImageView];
         */
        
        /* persist test by jeanclad
         VenusPersistList *persistList = [[VenusPersistList alloc] init];
         
         [persistList setPhotoItemName:@"Venus1"];
         [persistList setPaperPhotoFileName:@"Screenshot1.png"];
         [persistList setPaperlessPhotoFileName:@"Venus_paperless_1.png"];
         [persistList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_CRUMPLED]];
         [persistList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_1620]];
         
         [persistList fillPlistData];
         
         [persistList setPhotoItemName:@"Venus2"];
         [persistList setPaperPhotoFileName:@"Screenshot2.png"];
         [persistList setPaperlessPhotoFileName:@"Venus_paperless_2.png"];
         [persistList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_NORMAL]];
         [persistList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_DEVELOP_PINK]];
         
         [persistList fillPlistData];
         
         [persistList setPhotoItemName:@"Venus3"];
         [persistList setPaperPhotoFileName:@"Screenshot3.png"];
         [persistList setPaperlessPhotoFileName:@"Venus_paperless_3.png"];
         [persistList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_POLAROID]];
         [persistList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_DEVELOP_GREEN]];
         
         [persistList fillPlistData];
         
         [persistList setPhotoItemName:@"Venus4"];
         [persistList setPaperPhotoFileName:@"Screenshot4.png"];
         [persistList setPaperlessPhotoFileName:@"Venus_paperless_4.png"];
         [persistList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_ROLLED_UP]];
         [persistList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_GLOOM]];
         
         [persistList fillPlistData];
         
         [persistList setPhotoItemName:@"Venus5"];
         [persistList setPaperPhotoFileName:@"Screenshot5.png"];
         [persistList setPaperlessPhotoFileName:@"Venus_paperless_5.png"];
         [persistList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_SPRING]];
         [persistList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_SUNNY]];
         
         [persistList fillPlistData];
         
         NSMutableData *data = [[NSMutableData alloc] init];
         NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
         initForWritingWithMutableData:data];
         [archiver encodeObject:persistList forKey:kDataKey];
         [archiver finishEncoding];
         [data writeToFile:[self dataFilePath] atomically:YES];
         
         //NSLog(@"persistList_load = %@", persistList.persistList);
         */
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /* 메인 중앙 이미지 버튼이 없어질 때
     1. 필름 선택뷰로 넘어갔을때
     2. 사진 찍어서 선택되었을때
     */
    [selectedButton removeFromSuperview];
    
    /* 필름 선택뷰에서 넘어온 selectedAssets값이 해당 class가 pop 되면서 더이상 접어서 nil이 넘어온다.
     그래서 asset값을 강제로 nil로 만든다음 필름 뷰에서 nil이 넘어오면 필름뷰에서 사진을 선택하지 않고 Back 키로
     넘어왔다고 판단해서 예전에 저장해 놓은 이미지를 사용하여 Custom Button을 꾸민다.
     */
    asset = nil;
    [GlobalDataManager sharedGlobalDataManager].selectedAssets = nil;
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setSelectView:nil];
    [self setUnderBarItemView:nil];
    [self setPincetteImage:nil];
    [self setMainSecondView:nil];
    [self setPincetteImage:nil];
    [self setLightButton:nil];
    [self setDarkRoomInUseTitle:nil];
    [self setLamp:nil];
    [self setBigSteel:nil];
    [self setRoom:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagepickerController = [[UIImagePickerController alloc]init];
    [imagepickerController setDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self];
    [imagepickerController setAllowsEditing:NO];
    
    NSString *string1 = NSLocalizedString(@"ErrCameraTitle", @"카메라 에러 타이틀");
    NSString *string2 = NSLocalizedString(@"ErrCameraMessage", @"카메라 에러 메세지");
    NSString *string3 = NSLocalizedString(@"Cancel", "취소");
    
    if (buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
            [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagepickerController.allowsEditing = YES;
            
            [self presentModalViewController:imagepickerController animated:YES];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            [alert show];
        }
    } else if (buttonIndex == 1){
        VenusFilmGroupViewController *VenusFilmGroupView = [[VenusFilmGroupViewController alloc] initWithNibName:@"VenusFilmGroupViewController" bundle:nil];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor clearColor];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:VenusFilmGroupView animated:YES];
        //        [self.navigationController presentModalViewController:VenusFilmGroupView animated:YES];
    }
    
}


#pragma mark - Alert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"button = %d", buttonIndex);
    
    //---   비이커 비움 alert의 버튼 처리
    if (buttonIndex == 0){
        [self performSelectorOnMainThread:@selector(setEmptyBeaker:) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [GlobalDataManager sharedGlobalDataManager].selectedAssets = nil;
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage = shrinkImage(chosenImage, selectedButton.frame.size);
    mainPhotoView = shrunkenImage;
    firstSelect = YES;
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark  -NSAnimation Delegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"%s", __FUNCTION__);
    //--- 현상액 애니메이션 중일때는 터치 이벤트를 받도록 함
    chemicalAni.chemicalAnimating = NO;
    //--- 현상액 애니메이셩 중일때는 chemicalScrollView의 scroll이 발생하도록 함
    [chemicalScrollView setUserInteractionEnabled:YES];
    [waitBaekerProgressTimer fire];
    [stopBeakerProgressTimer fire];
}


#pragma mark  -UIScrollView Delegate 
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == paperScrollView){
        CGFloat pageHeight = paperScrollView.frame.size.height;
        paperPageControl.currentPage = floor((paperScrollView.contentOffset.y - pageHeight / 7) / pageHeight) + 1;
    }
    else if (sender == chemicalScrollView){
        CGFloat pageHeight = paperScrollView.frame.size.height;
        chemicalPageControl.currentPage = floor((chemicalScrollView.contentOffset.y - pageHeight / 9) / pageHeight) + 1;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //---   PaperView
    if (scrollView == paperScrollView){
        //---   용지가 먼저 보이고 그 위에 사진이 디졸브 되는 애니메이션을 위해서 selectedButton과 동일한 위치와 동일한 크기로 용지를 먼저 보이게 한다.
		UIImage *image = [UIImage imageNamed:
						  [NSString stringWithFormat:@"paper_preview_%d.png", paperPageControl.currentPage]];
        paperPreviewImageView.image = image;
        [paperPreviewImageView setHidden:NO];
        
        [self setPaperPreviewImage];
        [selectedButton setBackgroundImage:preview_img forState:UIControlStateNormal];
        [selectedButton setAlpha:0];
        
        [UIView beginAnimations:@"PaperPhoto" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2];
        [UIView setAnimationDelay:0.5f];
        [selectedButton setAlpha:1.0];
        
        [UIView commitAnimations];
        //---   ChemicalView
    } else{
        ;
    }
}


#pragma mark  -jeanclad
// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

- (void) showAlbumView:(id)sender
{
    VenusAlbumPageViewController *venusAlbumPageView = [[VenusAlbumPageViewController alloc] initWithNibName:@"VenusAlbumPageViewController" bundle:nil];
    venusAlbumPageView.rootNaviController = self.navigationController;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:venusAlbumPageView animated:YES];
    
    [self setLightOffNotAnimationItem];
}

- (void)setChemicalView
{
    [self moveAnimationRootView:YES];
    [self setHiddenRootItem:YES];
    
    [paperScrollView setHidden:YES];
    [paperPageControl setHidden:YES];
    [chemicalScrollView setHidden:NO];
    [chemicalPageControl setHidden:NO];
    [beakerView setHidden:NO];
    MainVIewMoved = YES;
}

- (void)setPaperView
{
    [self moveAnimationRootView:YES];
    [self setHiddenRootItem:YES];
    
    [paperScrollView setHidden:NO];
    [paperPageControl setHidden:NO];
    [chemicalScrollView setHidden:YES];
    [chemicalPageControl setHidden:YES];
    [beakerView setHidden:YES];
    MainVIewMoved = YES;
}

- (void)moveAnimationRootView:(BOOL)move
{
    if (move == YES){
        [selectedButton setUserInteractionEnabled:NO];
        if (developing == NO)
            [self showMainSecondView];
        else
            [self showMainSecondViewForDeveloping];
    }
    else{
        [selectedButton setUserInteractionEnabled:YES];
        [self showMainView];
    }
}

-(void)showMainView
{
    float moveViewXpos = 0;
    float moveButtonXpos = 0;
    
    if (myDevice == MYDEVICE_IPHONE5){
        moveViewXpos = SELECT_RIGHT_MOVE_X_IP5;
        moveButtonXpos = IP5_SIZE_WIDTH;
    }
    else{
        moveViewXpos = SELECT_RIGHT_MOVE_X_IP4;
        moveButtonXpos = IP4_SIZE_WIDTH;
    }
    
    //---   핀셋과 사진을 MainView에 맞는 위치와 크기로 변경한다.
    self.pincetteImage.frame = CGRectMake(40, 210, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    selectedButton.frame = CGRectMake(moveButtonXpos/2-70, IP4_IP5_SIZE_HEIGHT/2-90, PREVIEW_NO_MOVE_FRAME_SIZE_WIDTH, PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT);
    
    
    //---   MainSecondView 가 뒤집히면서 MainView가 보이게 한다
    [UIView transitionWithView:self.MainView duration:MAINVIEW_ANIMATION_DURATION*2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.MainSecondView setHidden:YES];
                    }completion:^(BOOL finished) {
                        //---   MainView가 좌측으로 이동하게 한다.
                        [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION
                                              delay: 0.0
                                            options: UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.MainView.frame = CGRectMake(self.MainView.frame.origin.x - moveViewXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
                                         }
                                         completion:^(BOOL finished){
                                             ;
                                         }];
                        
                    }];
}



-(void)showMainSecondView
{
    float moveXpos = 0;
    
    if (myDevice == MYDEVICE_IPHONE5)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    
    //---   MainView가 우측으로 이동한다.
    [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.MainView.frame = CGRectMake(self.MainView.frame.origin.x + moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //--- MainView가 뒤집히면서 MainSecondView가 나타나며 암실 트레이가 보인다.
                         [UIView transitionWithView:self.MainView duration:MAINVIEW_ANIMATION_DURATION*2
                                            options:UIViewAnimationOptionTransitionFlipFromLeft
                                         animations:^{
                                             [self.MainSecondView setHidden:NO];
                                         }completion:^(BOOL finished) {
                                             //---   사진과 핀셋이 MainSecondView의 좌측 상단에서 점점 내려오면서 뚜렷하게 보이게 한다.
                                             [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION*2
                                                                   delay: 0.0
                                                                 options: UIViewAnimationOptionCurveEaseInOut
                                                              animations:^{
                                                                  [selectedButton setAlpha:1];
                                                                  selectedButton.frame = CGRectMake(SELECT_BUTTON_MOVE_X_IP4, SELECT_BUTTON_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
                                                                  self.pincetteImage.frame = CGRectMake(0, 200, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
                                                                  [self.pincetteImage setAlpha:1];
                                                              }
                                                              completion:^(BOOL finished){
                                                                  ;
                                                              }];
                                             
                                         }];
                         //---   사진이 MainSceondView에 움직이기 위해서 좌측으로 빠져있게 한다. 사진이 점점 뚜렷하게 보이게 하기 위해서 alpha 값을 0으로 설정한다.
                         selectedButton.frame = CGRectMake(0, -170, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
                         [selectedButton setAlpha:0];
                         
                         //---   핀셋이 사진을 잡고 MainSecondView로 움직이기 위해서 좌측으로 빠져있게 한다. 핀셋이 점점 뚜렷하게 보이게 하기 위해서 alpha값을 0으로 설정한다
                         self.pincetteImage.frame = CGRectMake(0, -30, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
                         [self.pincetteImage setAlpha:0];
                         
                     }];
    
}

-(void)showMainSecondViewForDeveloping
{
    float moveViewXpos = 0;
    float movePincetteXpos = 0;
    
    if (myDevice == MYDEVICE_IPHONE5){
        moveViewXpos = SELECT_RIGHT_MOVE_X_IP5;
        movePincetteXpos = 90;
    }
    else{
        moveViewXpos = SELECT_RIGHT_MOVE_X_IP4;
        movePincetteXpos = 70;
    }
    
    //---   MainView가 우측으로 이동한다.
    [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.MainView.frame = CGRectMake(self.MainView.frame.origin.x + moveViewXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
                     }completion:^(BOOL finished){
                         //--- MainView가 뒤집히면서 MainSecondView가 나타나며 암실 트레이가 보인다.
                         [UIView transitionWithView:self.MainView
                                           duration:MAINVIEW_ANIMATION_DURATION*2
                                            options:UIViewAnimationOptionTransitionFlipFromLeft
                                         animations:^{
                                             [self.MainSecondView setHidden:NO];
                                         }completion:^(BOOL finished) {
                                             //---   사진과 핀셋이 MainSecondView의 좌측 상단에서 점점 내려오면서 뚜렷하게 보이게 한다.
                                             [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION*2
                                                                   delay: 0.0
                                                                 options: UIViewAnimationOptionCurveEaseInOut
                                                              animations:^{
                                                                  //---   사진 인화시에는 용지가 먼저 보이게 하고 인화작업 도중 점점 사진이 보이게 한다. 사진인화시에는 selectedButton을 사용하지 않고 동일한 sizei의 imageView를 생성하여 가속도 센서값이 맞게 움직이게 한다.
                                                                  /*
                                                                  UIImage *image = [UIImage imageNamed:
                                                                                    //[NSString stringWithFormat:@"paper_preview_%d.png", paperPageControl.currentPage]];
                                                                  
                                                                  [selectedButton setBackgroundImage:image forState:UIControlStateNormal];
                                                                   */
                                                                  [selectedButton setBackgroundImage:_bg forState:UIControlStateNormal];
                                                                  [selectedButton setAlpha:1.0f];
                                                        
                                                                  CGSize developingPhotoImageSize = [self getDevelopingPhotoSize];
                                                                  developingPhotoImageView.image = mainPhotoView;
                                                                  developingPhotoImageView.frame = CGRectMake(0, 0, developingPhotoImageSize.width, developingPhotoImageSize.height);

                                                                  selectedButton.frame = CGRectMake(SELECT_BUTTON_MOVE_X_IP4, SELECT_BUTTON_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
                                                                  self.pincetteImage.frame = CGRectMake(0, 200, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
                                                                  [self.pincetteImage setAlpha:1];
                                                              } completion:^(BOOL finished){
                                                                  [self beakerDropAnimation];
                                                                  //---   트레이에 사진 용액이 점점 퍼지게 하는 애니메이션
                                                                  [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION*6
                                                                                        delay: MAINVIEW_ANIMATION_DELAY
                                                                                      options: UIViewAnimationOptionCurveEaseOut
                                                                                   animations:^{
                                                                                       [self setEmptyBeaker:self];
                                                                                       [waterImageView setAlpha:1];
                                                                                       [selectedButton setAlpha:DEVELOPING_PHOTO_ALPHA];                                                                                                                                                                                                   
                                                                                   } completion:^(BOOL finished){
                                                                                       //---   트레이가 완전히 보이게 하는 애니메이션 (Move Left)
                                                                                       [UIView animateWithDuration:MAINVIEW_ANIMATION_DURATION
                                                                                                             delay: 0.0
                                                                                                           options:UIViewAnimationOptionCurveEaseOut
                                                                                                        animations:^{
                                                                                                            self.MainView.frame = CGRectMake(self.MainView.frame.origin.x - moveViewXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
                                                                                                            
                                                                                                            //---   트레이가 좌측으로 이동했으므로 사진도 좌측으로 이동시킨다. (현재 selectedButton에는 paper이미지가 설정되어 있다.
                                                                                                            if (myDevice == MYDEVICE_IPHONE5)
                                                                                                                selectedButton.center = CGPointMake(IP5_SIZE_WIDTH/2, IP4_IP5_SIZE_HEIGHT/2);
                                                                                                            else
                                                                                                                selectedButton.center = CGPointMake(IP4_SIZE_WIDTH/2, IP4_IP5_SIZE_HEIGHT/2);
                                                                                                            
                                                                                                            self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x + movePincetteXpos, self.pincetteImage.frame.origin.y, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
                                                                                                            
                                                                                                        }completion:^(BOOL finished) {
                                                                                                            //---   가속도 센서 설정
                                                                                                            if (motionManager == nil){
                                                                                                                motionManager = [[CMMotionManager alloc] init];
                                                                                                            }
                                                                                                            
                                                                                                            if (motionManager.accelerometerAvailable){
                                                                                                                //---   사진 인화 프로그레스바 초기화 / selectedButton이 View초기화 시점에는 사진이미지가 적용되기 전이므로 ViewWillAni.. 부분에 적용할수 없고 selectedButton에 이미지가 설정됭후 addSubview를 한다.
                                                                                                                if (devleopingProgress == nil){
                                                                                                                    devleopingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                                                                                                                    devleopingProgress.frame = CGRectMake(20, 170, 160, 0);
                                                                                                                }
                                                                                                                developingProgressLevel = 0.0f;
                                                                                                                [devleopingProgress setProgress:developingProgressLevel];
                                                                                                                [devleopingProgress setHidden:NO];
                                                                                                                [selectedButton addSubview:devleopingProgress];
                                                                                                                
                                                                                                                //---   사진인화시 사용되는 아이템 초기화
                                                                                                                lastUpdateTime = nil;
                                                                                                                photoXVelocity = 0;
                                                                                                                photoYVelocity = 0;

                                                                                                                //---   사진인화시 용지의 시작점 설정 currentPoint의 x,y 값이 실좌표와 반대이므로 x,y 를 반대로 설정해줘야함
                                                                                                                currentPoint.x = selectedButton.frame.origin.y;
                                                                                                                currentPoint.y = selectedButton.frame.origin.x;
                                                                                                                
                                                                                                                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                                                                                                                motionManager.accelerometerUpdateInterval = kUpdateInterval;
                                                                                                                [motionManager startAccelerometerUpdatesToQueue:queue withHandler:
                                                                                                                 ^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                                                                                     acceleration = accelerometerData.acceleration;
                                                                                                                     [self performSelectorOnMainThread:@selector(updatePhotoPostion)
                                                                                                                                            withObject:nil waitUntilDone:NO];
                                                                                                                 }];
                                                                                                            }
                                                                                                        }];
                                                                                   }];
                                                                  
                                                                  
                                                              }];
                                             
                                         }];
                         //---   사진이 MainSceondView에 움직이기 위해서 좌측으로 빠져있게 한다. 사진이 점점 뚜렷하게 보이게 하기 위해서 alpha 값을 0으로 설정한다.
                         selectedButton.frame = CGRectMake(0, -170, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
                         [selectedButton setAlpha:0];
                         
                         //---   핀셋이 사진을 잡고 MainSecondView로 움직이기 위해서 좌측으로 빠져있게 한다. 핀셋이 점점 뚜렷하게 보이게 하기 위해서 alpha값을 0으로 설정한다
                         self.pincetteImage.frame = CGRectMake(0, -30, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
                         [self.pincetteImage setAlpha:0];
                         
                     }];
}


- (void)showPincetteOffAnimation
{
    //---   사진인화가 완료되면 핀셋이 우측으로 이동하면서 사진도 함께 우측으로 이동하게 한다.
    [UIView beginAnimations:@"PincettOff" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2];
    self.pincetteImage.frame = CGRectMake(0, -30, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [self.pincetteImage setAlpha:0];
    [UIView commitAnimations];
    
}

- (void)showPincetteOnAnimation
{
    [UIView beginAnimations:@"PincettOn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showPincetteOnAnimationDone)];
    self.pincetteImage.frame = CGRectMake(currentPoint.y-90, currentPoint.x+150, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [self.pincetteImage setAlpha:1];
    [UIView commitAnimations];
    
}

- (void)showPincetteOnAnimationDone
{
    float moveX = 0;
    if (myDevice == MYDEVICE_IPHONE5)
        moveX = IP5_SIZE_WIDTH;
    else
        moveX = IP4_SIZE_WIDTH;
    
    [UIView beginAnimations:@"selectedButtonToAlbum" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    selectedButton.frame = CGRectMake(moveX, selectedButton.frame.origin.y, selectedButton.frame.size.width, selectedButton.frame.size.height);
    [selectedButton setAlpha:0.0f];
    //---   사진 인화시 사용되었던 사진 이미지는 용지가 우측으로 이동할때 함께 우측으로 이동하면서 알파값을 초기화한다.
    developingPhotoImageView.frame = CGRectMake(moveX, developingPhotoImageView.frame.origin.y, developingPhotoImageView.frame.size.width, developingPhotoImageView.frame.size.height);
        [developingPhotoImageView setAlpha:0.0f];
    self.pincetteImage.frame = CGRectMake(moveX, currentPoint.x+150, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [UIView commitAnimations];
}


- (void)setDevelopingComplete
{
    [devleopingProgress setHidden:YES];
    [waterImageView setAlpha:0.0f];
    [darkRoomOnSteelImageView setHidden:YES];
    [darkRoomOffSteelImageView setHidden:NO];
    [self.lightButton setImage:[UIImage imageNamed:@"switch_off_ip4.png"] forState:UIControlStateNormal];
    [self showPincetteOnAnimation];
    [self performSelector:@selector(showAlbumView:) withObject:nil afterDelay:2.0f];
}

- (void)setHiddenRootItem:(BOOL)isHidden
{
    if (isHidden == YES){
        [self.underBarItemView setHidden:YES];
        
        [UIView beginAnimations:@"anotheranimation" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.underBarItemView
                                 cache:NO];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
    } else {
        [self.underBarItemView setHidden:NO];
        
        [UIView beginAnimations:@"anotheranimation" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.underBarItemView
                                 cache:NO];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
    }
}

-(void) paperPageChangeValue:(id)sender
{
    NSLog(@"%s : sender = %@", __FUNCTION__, sender);
	UIPageControl *pControl = (UIPageControl *) sender;
	[paperScrollView setContentOffset:CGPointMake(0, pControl.currentPage * 290) animated:YES];
}

-(void) chemicalPageChangeValue:(id)sender
{
    NSLog(@"%s : sender = %@", __FUNCTION__, sender);
	UIPageControl *pControl = (UIPageControl *) sender;
	[chemicalScrollView setContentOffset:CGPointMake(0, pControl.currentPage * 290) animated:YES];
}

- (void) fillChemicalAnimation
{
    int chemicalRotationAngle = CHEMICAL_ROTATION_ANGLE;
    
    [chemicalAni setChemicalAniDuration];
    
    //---   Will edit position
    
    //---   애니메이션 시작 좌표는 실제 오브젝트 size의 높이, 너비를 2로 나눈 점에서 시작해야 한다.
    chemicalAni.chemicalStartX = 20;
    chemicalAni.chemicalStartY = [[chemicalImageView objectAtIndex:chemicalPageControl.currentPage] frame].origin.y + 50;
    
    //---   1. 첫번째 애니메이션 : 현상액 위로 위치이동
    int cx1 = chemicalAni.chemicalStartX + chemicalAni.chemicalOffSetX;
    int cy1 = chemicalAni.chemicalStartY - chemicalAni.chemicalOffSetY;
    int cx2 = cx1 + chemicalAni.chemicalOffSetX;
    int cy2 = cy1 - chemicalAni.chemicalOffSetY;
    int cx3 = cx2 + chemicalAni.chemicalOffSetX;
    int cy3 = cy2 - chemicalAni.chemicalOffSetY;
    
    CAKeyframeAnimation * AnimationChemicalPathUp = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePathUp = CGPathCreateMutable();
    CGPathMoveToPoint(thePathUp, NULL, chemicalAni.chemicalStartX, chemicalAni.chemicalStartY);
    CGPathAddLineToPoint(thePathUp, NULL, cx1, cy1);
    CGPathAddLineToPoint(thePathUp, NULL, cx2, cy2);
    CGPathAddLineToPoint(thePathUp, NULL, cx3, cy3);
    
    AnimationChemicalPathUp.path = thePathUp;
    AnimationChemicalPathUp.calculationMode = kCAAnimationPaced;
    AnimationChemicalPathUp.duration = chemicalAni.firstAniDuration;
    AnimationChemicalPathUp.fillMode = kCAFillModeForwards;
    CFRelease(thePathUp);
    
    //---   2. 첫번째 애니에이션 : 현상액 회전
    CABasicAnimation *rotation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.fromValue = [NSNumber numberWithFloat:(0 * M_PI / 180.0)]; //0도에서 시작
    rotation.toValue = [NSNumber numberWithFloat:(chemicalRotationAngle * M_PI / 180.0)];
    rotation.duration = chemicalAni.firstAniDuration;
    rotation.fillMode = kCAFillModeForwards;
    
    //---   3. 두번째 애니메이션 : 현상액 아래로 위치이동
    int rev_x1 = cx3;
    int rev_y1 = cy3;
    
    int rev_cx1 = rev_x1 - chemicalAni.chemicalOffSetX;
    int rev_cy1 = rev_y1 + chemicalAni.chemicalOffSetY;
    int rev_cx2 = rev_cx1 - chemicalAni.chemicalOffSetX;
    int rev_cy2 = rev_cy1 + chemicalAni.chemicalOffSetY;
    int rev_cx3 = rev_cx2 - chemicalAni.chemicalOffSetX;
    int rev_cy3 = rev_cy2 + chemicalAni.chemicalOffSetY;
    
    CAKeyframeAnimation * AnimationChemicalPathDown = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePathDown = CGPathCreateMutable();
    CGPathMoveToPoint(thePathDown, NULL, rev_x1, rev_y1);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx1, rev_cy1);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx2, rev_cy2);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx3, rev_cy3);
    
    AnimationChemicalPathDown.path = thePathDown;
    AnimationChemicalPathDown.calculationMode = kCAAnimationPaced;
    AnimationChemicalPathDown.duration = chemicalAni.secondAniDuration;
    AnimationChemicalPathDown.beginTime = chemicalAni.secondAniBeginTime;
    AnimationChemicalPathDown.fillMode = kCAFillModeForwards;
    CFRelease(thePathDown);
    
    //---   4. 두번째 애니메이션 : 현상액 역회전
    CABasicAnimation *rotation2 =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation2.fromValue = [NSNumber numberWithFloat:(chemicalRotationAngle * M_PI / 180.0)]; //0도에서 시작
    rotation2.toValue = [NSNumber numberWithFloat:(0 * M_PI / 180.0)];
    rotation2.duration = chemicalAni.secondAniDuration;
    rotation2.beginTime  = chemicalAni.secondAniBeginTime;
    rotation2.fillMode = kCAFillModeForwards;
    
    //---   5. 애니메이션 그룹
    CAAnimationGroup *group = [CAAnimationGroup animation];
    // 아래와 같이 배열로 애니메이션을 초기화해서 셋하게되면 애니메이션 그룹으로 사용가능.
    group.animations = [NSArray arrayWithObjects:AnimationChemicalPathUp, rotation, AnimationChemicalPathDown, rotation2, nil];
    group.duration = chemicalAni.totalAniDuration;
    group.delegate = self;
    
    [[[chemicalImageView objectAtIndex:chemicalPageControl.currentPage] layer] addAnimation:group forKey:nil];
    
    //--- 현상액 애니메이션 중일때는 터치 이벤트를 받지 않도록 함
    chemicalAni.chemicalAnimating = YES;
    //--- 현상액 애니메이셩 중일때는 chemicalScrollView의 scroll이 발생하지 않도록 함
    [chemicalScrollView setUserInteractionEnabled:NO];
}

- (void) beakerDropAnimation
{
    [self showPincetteOffAnimation];
    int beakerRotationAngle = BEAKER_ROTATION_ANGLE;
    
    //---   Will edit position
    //---   애니메이션 시작 좌표는 실제 오브젝트 size의 높이, 너비를 2로 나눈 점에서 시작해야 한다.
    int beakerStartX = beakerView.frame.origin.x + beakerView.frame.size.width/2;
    int beakerStartY = beakerView.frame.origin.y + beakerView.frame.size.height/2;
    
    int beakerOffsetX = 5;
    //int beakerOffsetY = 20;
    int beakerOffsetY = 5;
    
    //---   1. 첫번째 애니메이션 : 현상액 위로 위치이동
    int cx1 = beakerStartX - beakerOffsetX;
    int cy1 = beakerStartY - beakerOffsetY;
    int cx2 = cx1 - beakerOffsetX;
    int cy2 = cy1 - beakerOffsetY;
    int cx3 = cx2 - beakerOffsetX;
    int cy3 = cy2 - beakerOffsetY;
    
    float firstAniDuration = 0.5f;
    float secondAniDuration = 0.5f;
    float waterDropAniDuration = 2.5f;
    float secondAniBeginTime = 3.0f;
    float totalAniDuration = firstAniDuration + waterDropAniDuration + secondAniDuration;
    
    CAKeyframeAnimation * AnimationChemicalPathUp = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePathUp = CGPathCreateMutable();
    CGPathMoveToPoint(thePathUp, NULL, beakerStartX, beakerStartY);
    CGPathAddLineToPoint(thePathUp, NULL, cx1, cy1);
    CGPathAddLineToPoint(thePathUp, NULL, cx2, cy2);
    CGPathAddLineToPoint(thePathUp, NULL, cx3, cy3);
    
    AnimationChemicalPathUp.path = thePathUp;
    AnimationChemicalPathUp.calculationMode = kCAAnimationPaced;
    AnimationChemicalPathUp.duration = firstAniDuration;
    AnimationChemicalPathUp.fillMode = kCAFillModeForwards;
    CFRelease(thePathUp);
    
    //---   2. 첫번째 애니에이션 : 현상액 회전
    CABasicAnimation *rotation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.fromValue = [NSNumber numberWithFloat:(0 * M_PI / 180.0)]; //0도에서 시작
    rotation.toValue = [NSNumber numberWithFloat:(beakerRotationAngle * M_PI / 180.0)];
    rotation.duration = firstAniDuration;
    rotation.fillMode = kCAFillModeForwards;
    
    //---   3. 두번째 애니메이션 : 현상액 아래로 위치이동
    int rev_x1 = cx3;
    int rev_y1 = cy3;
    
    int rev_cx1 = rev_x1 + beakerOffsetX;
    int rev_cy1 = rev_y1 + beakerOffsetY;
    int rev_cx2 = rev_cx1 + beakerOffsetX;
    int rev_cy2 = rev_cy1 + beakerOffsetY;
    int rev_cx3 = rev_cx2 + beakerOffsetX;
    int rev_cy3 = rev_cy2 + beakerOffsetY;
    
    CAKeyframeAnimation * AnimationChemicalPathDown = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePathDown = CGPathCreateMutable();
    CGPathMoveToPoint(thePathDown, NULL, rev_x1, rev_y1);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx1, rev_cy1);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx2, rev_cy2);
    CGPathAddLineToPoint(thePathDown, NULL, rev_cx3, rev_cy3);
    
    AnimationChemicalPathDown.path = thePathDown;
    AnimationChemicalPathDown.calculationMode = kCAAnimationPaced;
    AnimationChemicalPathDown.duration = secondAniDuration;
    AnimationChemicalPathDown.beginTime = secondAniBeginTime;
    AnimationChemicalPathDown.fillMode = kCAFillModeForwards;
    CFRelease(thePathDown);
    
    //---   4. 두번째 애니메이션 : 현상액 역회전
    CABasicAnimation *rotation2 =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation2.fromValue = [NSNumber numberWithFloat:(beakerRotationAngle * M_PI / 180.0)]; //0도에서 시작
    rotation2.toValue = [NSNumber numberWithFloat:(0 * M_PI / 180.0)];
    rotation2.duration = secondAniDuration;
    rotation2.beginTime  = secondAniBeginTime;
    rotation2.fillMode = kCAFillModeForwards;
    
    //---   5. 애니메이션 그룹
    CAAnimationGroup *group = [CAAnimationGroup animation];
    // 아래와 같이 배열로 애니메이션을 초기화해서 셋하게되면 애니메이션 그룹으로 사용가능.
    group.animations = [NSArray arrayWithObjects:AnimationChemicalPathUp, rotation, AnimationChemicalPathDown, rotation2, nil];
    group.duration = totalAniDuration;
    group.delegate = self;
    
    [[beakerView layer] addAnimation:group forKey:nil];
    
    //--- 현상액 애니메이션 중일때는 터치 이벤트를 받지 않도록 함
    chemicalAni.chemicalAnimating = YES;
    //--- 현상액 애니메이셩 중일때는 chemicalScrollView의 scroll이 발생하지 않도록 함
    [chemicalScrollView setUserInteractionEnabled:NO];
}

- (void)setLightOnAnimation
{
    UIImage *image = nil;
    
    image = [UIImage imageNamed:@"lamp_on_ip4.png"];
    [self.lamp setImage:image];
    
    image = [UIImage imageNamed:@"01_1main_on_ip4.png"];
    [self.room setImage:image];
    
    image = [UIImage imageNamed:@"title_on_ip4.png"];
    [self.darkRoomInUseTitle setImage:image];
    
    image = [UIImage imageNamed:@"steel_on_ip4.png"];
    [self.bigSteel setImage:image];
    
    [self.lamp setAlpha:0.3];
    [self.room setAlpha:0.3];
    [self.bigSteel setAlpha:0.3];
    
    //---   Dark Room In Use 네온사인만 먼저 On 시키고 나머지 아이템은 애니메이션 처리함
    [UIView beginAnimations:@"SwitchOff" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2];
    [UIView setAnimationDidStopSelector:@selector(setChemicalView)];
    [UIView setAnimationDelegate:self];
    
    [self.lamp setAlpha:1];
    [self.room setAlpha:1];
    [self.bigSteel setAlpha:1];
    
    [UIView commitAnimations];
}

- (void)setLightOffNotAnimationItem
{
    UIImage *image = nil;
    
    image = [UIImage imageNamed:@"lamp_off_ip4.png"];
    [self.lamp setImage:image];
    
    image = [UIImage imageNamed:@"01_1main_off_ip4.png"];
    [self.room setImage:image];
    
    image = [UIImage imageNamed:@"title_off_ip4.png"];
    [self.darkRoomInUseTitle setImage:image];
    
    image = [UIImage imageNamed:@"steel_off_ip4.png"];
    [self.bigSteel setImage:image];
    
    [darkRoomOnSteelImageView setHidden:YES];
    [darkRoomOffSteelImageView setHidden:NO];
    [self.MainSecondView setHidden:YES];
    [self setHiddenRootItem:NO];
    [chemicalContentView setHidden:NO];
    
    developing = NO;
    MainVIewMoved = NO;
}


#pragma mark  -jeanclad
#pragma mark  -BeakerView Control
- (void)fillBaakerProgress
{
    float chemicalLevelPerOnce = [chemicalAni getChemicalPerOnceLevel:[chemicalAni selectedChemicalIndex]];
    [self setProgressType:2 alpha:PROGRRESS_FILL_IMAGE_ALPHA setProgress:chemicalLevelPerOnce];
}

- (void)stopBeakerProgress
{
    [fillBeakerTimer invalidate];
}

- (void)setProgressType:(int)fillColor alpha:(float)alpha setProgress:(float)setProgress
{
    BOOL isMaxProgress = [beakerView isMaxProgress];
    if (isMaxProgress == NO){
        [beakerView setFillImage:fillColor alpha:alpha];
        float willProgress = [beakerView calculateOverProgress:setProgress];
        NSLog(@"willProgress = %f", willProgress);
        
        // set a timer that updates the progress
        wantProgressLevel = willProgress;
        fillBeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f target: self selector: @selector(updateProgress) userInfo: nil repeats: YES];
        [[NSRunLoop mainRunLoop] addTimer:fillBeakerTimer forMode:NSRunLoopCommonModes];
        
        [fillBeakerTimer fire];
        
        stopBeakerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:([chemicalAni waterDropAniDuration] - [chemicalAni firstAniDuration]) target:self selector:@selector(stopBeakerProgress) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:stopBeakerProgressTimer forMode:NSRunLoopCommonModes];
        
    }
}

- (void)showBeakerEmptyAlertView
{
    NSString *string1;
    NSString *string2;
    NSString *string3;
    NSString *string4;
    
    //---   비이커의 현재 용액이 비어 있으면 더이상 비울수 없다는 alert를 띄우고, 아닌 경우에는 비이커를 비우는 alert를 띄운다.
    if ([beakerView isMinProgress]){
        string1 = NSLocalizedString(@"EmptyTrayTitle", @"트레이 비어있음 타이틀");
        string2 = NSLocalizedString(@"EmptyTrayMessage", @"트레이 비어있음 메세지");
        string3 = NSLocalizedString(@"OK", "확인");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:self cancelButtonTitle:string3 otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        string1 = NSLocalizedString(@"NoRoomInTrayTitle", @"트레이 비움 타이틀");
        string2 = NSLocalizedString(@"NoRoomInTrayMessage", @"트레이 비움 메세지");
        string3 = NSLocalizedString(@"EmptyTray", "트레이 비움 버튼");
        string4 = NSLocalizedString(@"OK", "확인");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:self cancelButtonTitle:string3 otherButtonTitles:string4, nil];
        [alert show];
    }
}

- (void)setEmptyBeaker:(id)sendor
{
    // set a timer that updates the progress
    //---   비이커가 비워지게 한다.
    wantProgressLevel = 0;
    fillBeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f target: self selector: @selector(updateProgress) userInfo: nil repeats: YES];
    [[NSRunLoop mainRunLoop] addTimer:fillBeakerTimer forMode:NSRunLoopCommonModes];
    [fillBeakerTimer fire];
    
    stopBeakerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:BEAKER_DROP_WATER_TIME target:self selector:@selector(stopBeakerProgress) userInfo:nil repeats:NO];
    
}


#pragma mark  -jeanclad
#pragma mark  -Accel Sensor Control
- (void)setPhotoAndPaperDevleopingMoveCenterPosion:(CGPoint)startPoint
{
    CGPoint centerPoint;
    
    centerPoint.y = startPoint.y + (PREVIEW_FRAME_SIZE_WIDTH / 2);
    centerPoint.x = startPoint.x + (PREVIEW_FRAME_SIZE_HEIGHT / 2);

    selectedButton.center = CGPointMake(centerPoint.y, centerPoint.x);
    developingPhotoImageView.center = CGPointMake(centerPoint.y, centerPoint.x);
    
    
    [developingPhotoImageView setAlpha:photoDevelopingAlpha];
}

- (void)setCurrentPoint:(CGPoint)newPoint {
    currentPoint = newPoint;
    CGPoint beakerEndPoint;
    beakerEndPoint.y = currentPoint.y + PREVIEW_FRAME_SIZE_WIDTH;
    beakerEndPoint.x = currentPoint.x + PREVIEW_FRAME_SIZE_HEIGHT;
    
    if (currentPoint.y < BIG_BEAKER_START_X_IP4){
        currentPoint.y = BIG_BEAKER_START_X_IP4;
        photoYVelocity = 0;
    }
    
    if (currentPoint.x < BIG_BEAKER_START_Y_IP4) {
        currentPoint.x = BIG_BEAKER_START_Y_IP4;
        photoXVelocity = 0;
    }
    
    if (beakerEndPoint.y > BIG_BEAKER_END_X_IP4) {
        currentPoint.y = BIG_BEAKER_END_X_IP4 - PREVIEW_FRAME_SIZE_WIDTH;
        photoYVelocity = 0;
    }
    
    if (beakerEndPoint.x > BIG_BEAKER_END_Y_IP4) {
        currentPoint.x = BIG_BEAKER_END_Y_IP4 - PREVIEW_FRAME_SIZE_HEIGHT;
        photoXVelocity = 0;
    }
    
    [self setPhotoAndPaperDevleopingMoveCenterPosion:currentPoint];
    
    //if (photoDevelopingAlpha > 1){
    if (developingProgressLevel > 1){
        NSLog(@"photoDevelopingAlpha = %f", photoDevelopingAlpha);
        [motionManager stopAccelerometerUpdates];
        photoDevelopingAlpha = 0.0f;
        [self setDevelopingComplete];
        return;
    }
    
    if (photoYVelocity > 0.1 || photoYVelocity < -0.1){
        photoDevelopingAlpha += 0.002;
        developingProgressLevel += 0.005;
        devleopingProgress.progressTintColor = [UIColor redColor];
        [devleopingProgress setProgress:developingProgressLevel animated:YES];
    } else{
        photoDevelopingAlpha += 0.0002;
        developingProgressLevel += 0.0005;
        devleopingProgress.progressTintColor = [UIColor blueColor];
        [devleopingProgress setProgress:developingProgressLevel animated:YES];
    }
    
    //NSLog(@"paper = %@", NSStringFromCGPoint(selectedButton.frame.origin));
}

- (void)updatePhotoPostion {
    //NSLog(@"accel = %f, %f", acceleration.x, acceleration.y);
    
    if (motionManager.accelerometerActive == YES){
        if (lastUpdateTime != nil) {
            NSTimeInterval secondsSinceLastDraw =
            -([lastUpdateTime timeIntervalSinceNow]);
            
            photoYVelocity = photoYVelocity + -(acceleration.y * secondsSinceLastDraw);
            photoXVelocity = photoXVelocity + -(acceleration.x * secondsSinceLastDraw);
            
            CGFloat xAcceleration = secondsSinceLastDraw * photoXVelocity * 500;
            CGFloat yAcceleration = secondsSinceLastDraw * photoYVelocity * 500;
            //NSLog(@"yAcc = %f(%f), xAcc = %f(%f)", yAcceleration, photoYVelocity, xAcceleration, photoXVelocity);
            
            currentPoint = CGPointMake(currentPoint.x + xAcceleration, currentPoint.y + yAcceleration);
            
            //[self setCurrentPoint:CGPointMake(currentPoint.x + xAcceleration, currentPoint.y + yAcceleration)];
            [self setCurrentPoint:currentPoint];
            
        }
        // Update last time with current time
        lastUpdateTime = [[NSDate alloc] init];
    }
}

- (void)updateProgress
{
    CGFloat currentProgress = [beakerView progress];
    CGFloat progressDir = 0.00f;
    
    if (float_equal(wantProgressLevel, 0)){
        progressDir = -1.0f;
        if (currentProgress >= 0){
            currentProgress += (0.01f * progressDir);
            [beakerView setProgress: currentProgress];
        }
    }else {
        progressDir = 1.0f;
        
        if (float_equal(wantProgressLevel, currentProgress)){
            if (float_equal(currentProgress, 0)){
                currentProgress += (0.01f * progressDir);
                [beakerView setProgress: currentProgress];
            }
            
        } else if (wantProgressLevel > currentProgress){
            if (currentProgress < wantProgressLevel){
                currentProgress += (0.01f * progressDir);
                [beakerView setProgress: currentProgress];
            }
        }
    }
    
    NSLog(@"wantProgress = %f, 1 currentProgress = %f", wantProgressLevel, currentProgress);
}


#pragma mark  -jeanclad
#pragma mark  -ImageEditing
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale,
                                                 size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, size.width * scale, size.height * scale),
                       original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}

- (UIImage*) makeThumbnailImage:(UIImage*)image onlyCrop:(BOOL)bOnlyCrop Size:(float)size
{
    CGRect rcCrop;
    if (image.size.width == image.size.height) {
        rcCrop = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    else if (image.size.width > image.size.height) {
        int xGap = (image.size.width - image.size.height)/2;
        rcCrop = CGRectMake(xGap, 0.0, image.size.height, image.size.height);
    }
    else {
        int yGap = (image.size.height - image.size.width)/2;
        rcCrop = CGRectMake(0.0, yGap, image.size.width, image.size.width);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rcCrop);
    UIImage* cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    if (bOnlyCrop)
        return cropImage;
    
    NSData* dataCrop = UIImagePNGRepresentation(cropImage);
    UIImage* imgResize = [[UIImage alloc] initWithData:dataCrop];
    
    UIGraphicsBeginImageContext(CGSizeMake(size,size));
    [imgResize drawInRect:CGRectMake(0.0f, 0.0f, size, size)];
    UIImage* imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgThumb;
}

-(UIImage *)maskingImage:(UIImage *)image maskImage:(UIImage *)_maskImage{
    CGImageRef imageRef = [image CGImage];
    CGImageRef maskRef = [_maskImage CGImage];
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    CGImageRelease(mask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return maskedImage;
}

-(UIImage *) shadowImage:(UIImage *)image{
    //3 pixel shadow blur 픽셀치를 조정해서 세도우 블뤄 효과의 크기를 조절할수 있습니다.
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width + 6, image.size.height + 6));
    CGContextSetShadow(UIGraphicsGetCurrentContext(),CGSizeMake(3.0f, -3.0f),3.0f);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setPaperPreviewImage
{
    NSLog(@"paperPagecontrol.currentPage = %d", paperPageControl.currentPage);
    
    //get character image
    UIImage *_previewPhoto = mainPhotoView;
    _bg = [UIImage imageNamed:[NSString stringWithFormat:@"paper_preview_%d.png", paperPageControl.currentPage]];
    if (_bg != nil) {
        UIGraphicsBeginImageContext(_bg.size);
        if ([paperPageControl currentPage] == PAPER_INDEX_WHITE){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_ORIGIN_X, PREVIEW_ORIGIN_Y, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        else if ([paperPageControl currentPage] == PAPER_INDEX_POLARIOD){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_POLAROID_FRAME_SIZE_WIDTH, PREVIEW_POLAROID_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_POLAROID_PHOTO_ORIGIN_X, PREVIEW_POLAROID_PHOTO_ORIGIN_Y, PREVIEW_POLAROID_PHOTO_SIZE_WIDTH, PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT)];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if([paperPageControl currentPage] == PAPER_INDEX_ROLLED_UP){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_ROLLED_UP_FRAME_SIZE_WIDTH, PREVIEW_ROLLED_UP_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_ROLLED_UP_PHOTO_ORIGIN_X, PREVIEW_ROLLED_UP_PHOTO_ORIGIN_Y, PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH, PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT)];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if ([paperPageControl currentPage] == PAPER_INDeX_SPRING){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_SPRING_FRAME_SIZE_WIDTH, PREVIEW_SPRING_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_SPRING_PHOTO_ORIGIN_X, PREVIEW_SPRING_PHOTO_ORIGIN_Y, PREVIEW_SPRING_PHOTO_SIZE_WIDTH, PREVIEW_SPRING_PHOTO_SIZE_HEIGHT)];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if ([paperPageControl currentPage] == PAPER_INDEX_VINTAGE){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_VINTAGE_FRAME_SIZE_WIDTH, PREVIEW_VINTAGE_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_VINTAGE_PHOTO_ORIGIN_X, PREVIEW_VINTAGE_PHOTO_ORIGIN_Y, PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH, PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [_previewPhoto drawInRect:CGRectMake(PREVIEW_ORIGIN_X, PREVIEW_ORIGIN_Y, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}

- (CGSize)getDevelopingPhotoSize
{
    CGSize photoSize;
    
    if ([paperPageControl currentPage] == PAPER_INDEX_WHITE){
        photoSize.width = PREVIEW_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_PHOTO_SIZE_HEIGHT;
    }else if ([paperPageControl currentPage] == PAPER_INDEX_POLARIOD){
        photoSize.width = PREVIEW_POLAROID_FRAME_SIZE_WIDTH;
        photoSize.height = PREVIEW_POLAROID_FRAME_SIZE_HEIGHT;
    }else if([paperPageControl currentPage] == PAPER_INDEX_ROLLED_UP){
        photoSize.width = PREVIEW_ROLLED_UP_FRAME_SIZE_WIDTH;
        photoSize.height = PREVIEW_ROLLED_UP_FRAME_SIZE_HEIGHT;
    }else if ([paperPageControl currentPage] == PAPER_INDeX_SPRING){
        photoSize.width = PREVIEW_SPRING_FRAME_SIZE_WIDTH;
        photoSize.height = PREVIEW_SPRING_FRAME_SIZE_HEIGHT;
    }else if ([paperPageControl currentPage] == PAPER_INDEX_VINTAGE){
        photoSize.width = PREVIEW_VINTAGE_FRAME_SIZE_WIDTH;
        photoSize.height = PREVIEW_VINTAGE_FRAME_SIZE_HEIGHT;
    }else{
        photoSize.width = PREVIEW_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_PHOTO_SIZE_HEIGHT;
    }
    
    return photoSize;
}

#pragma mark -
#pragma mark Persist Control
///* persist test by jeanclad
- (BOOL)loadPlistFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //---   아카이빙 으로 plist을 읽어온다.
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        [GlobalDataManager sharedGlobalDataManager].photoInfoFileList = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        //NSLog(@"loadPlist = %@ count = %d", loadPersistList.persistList, loadPersistList.persistList.count);
        //--------------------------------------------------------------------------------------------------
        
        
        //---   plist를 맨 마지막 저장된 것이 맨 처음 인덱스로 오도록 역순으로 sorting 한다.
        NSArray *allKeys = [[NSArray alloc] initWithArray:[[GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList allKeys]];
        NSLog(@"Allkeys = %@", allKeys);
        
        NSArray *tmpArray = [[NSArray alloc] initWithArray:allKeys];
        
        tmpArray = [allKeys sortedArrayUsingSelector:@selector(compare:)];
        //NSLog(@"sort = %@", tmpArray);
        
        NSEnumerator *enumReverse = [tmpArray reverseObjectEnumerator];
        NSString *tmpString;
        
        [GlobalDataManager sharedGlobalDataManager].reversePlistKeys = [[NSMutableArray alloc] init];
        
        while(tmpString = [enumReverse nextObject]){
            //NSLog(@"tmpString = %@", tmpString);
            [[GlobalDataManager sharedGlobalDataManager].reversePlistKeys addObject:tmpString];
        }
        
        NSLog(@"dictAllKeys = %@", [GlobalDataManager sharedGlobalDataManager].reversePlistKeys);
        
        /* Debug Code
         for (int i = 0; i < allKeys.count; i++){
         NSLog(@"first key paper type = %@", [[venusloadPlist.persistList objectForKey:[tmpDictArray objectAtIndex:i]] objectAtIndex:INDEX_PAPER_TYPE]);
         }
         */
        //---------------------------------------------------------------------------------------------------------------------------
        
        return YES;
    }
    return NO;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}
//*/


#pragma mark -
#pragma mark BUtton Action
- (void)buttonPressed:(UIButton *)sender {
    /*
     버튼종류를 알기위한 코드
     NSString *buttonName = [sender titleForState:UIControlStateNormal];
     NSLog(@"%@", buttonName);
     */
    
    NSString *string1 = NSLocalizedString(@"Cancel", @"취소");
    NSString *string2 = NSLocalizedString(@"ShootWithCamera", @"카메라");
    NSString *string3 = NSLocalizedString(@"SelectFromLibrary", @"사진앨범");
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:string1 destructiveButtonTitle:string2 otherButtonTitles:string3, nil];
    
    [actionsheet showInView:self.view];
}

- (IBAction)lightSwitchPressed:(UIButton *)sender {
    //---(1번안) 사진 용액을 하나도 추가 하지 않았거나 사진용지를 No Paper상태에서 변경하지 않으면 원본사진과 동일하므로 사진인화를 진행하지 않고 alertView를 띄운다. 사진용액을 추가 하였거나 사진 용지가 No Paper 상태가 아니라면 사진 인화를 진행한다.
    //if (((float_equal([beakerView progress], 0)) || ([beakerView progress] < 0)) && (paperPageControl.currentPage == PAPER_INDEX_WHITE)){
    //---(2번안) 사진 용액과 사진 용지 둘다 선택해야만 사진인화를 진행한다.
    if ((float_equal([beakerView progress], 0)) || ([beakerView progress] < 0)){
        NSString *string1 = NSLocalizedString(@"ErrDevelopingTitle", @"사진인화 에러 타이틀");
        NSString *string2 = NSLocalizedString(@"ErrDevelopingMessage", @"사진인화 에러 메세지");
        NSString *string3 = NSLocalizedString(@"OK", "확인");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
        [alert show];
    } else {
        developing = YES;
        //---   암실 트레이 이미지 설정
        [darkRoomOffSteelImageView setHidden:YES];
        [darkRoomOnSteelImageView setHidden:NO];
        
        [self.lightButton setImage:[UIImage imageNamed:@"switch_on_ip4.png"] forState:UIControlStateNormal];
        [self setHiddenRootItem:YES];
        [self setLightOnAnimation];
        [chemicalContentView setHidden:YES];
    }
}

- (IBAction)UnderButtonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);
    
    NSString *string1 = NSLocalizedString(@"NoPhotoTitle", @"사진 없음 메세지 타이틀");
    NSString *string2 = NSLocalizedString(@"NoPhotoMessage", @"사진 없음 메세지");
    NSString *string3 = NSLocalizedString(@"OK", "확인");
    
    if ([buttonName isEqualToString:@"Album"]){
        [self showAlbumView:self];
    }
    else if ([buttonName isEqualToString:@"Papers"]){
        if (firstSelect == YES){
            [self setPaperView];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([buttonName isEqualToString:@"Chemicals"]){
        if (firstSelect == YES){
            [self setChemicalView];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([buttonName isEqualToString:@"Info"]){
        VenusSelectDetailViewController *venusSelectDetailView = [[VenusSelectDetailViewController alloc] initWithNibName:@"VenusSelectDetailViewController" bundle:nil];
        
        //---   Chemical View
        if (paperScrollView.isHidden == YES){
            [venusSelectDetailView setItemValue:ITEM_VALUE_CHEMICAL];
            [venusSelectDetailView setCurrentItem:[chemicalPageControl currentPage]];
            
            //--- 용액 채우는 애니메이션 중 Info 버튼을 누르면 NSTimer가 중단되면서 비이커 레벨 채우는 작업이 중단된다.그래서 아래로 코드로 강제로 비이커 최종레벨로 셋팅한다.
            [beakerView setProgress: wantProgressLevel];
        }
        //---   Paper View
        else{
            [paperPreviewImageView setHidden:YES];
            [venusSelectDetailView setItemValue:ITEM_VALUE_PAPER];
            [venusSelectDetailView setCurrentItem:[paperPageControl currentPage]];
        }
        
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        self.navigationController.navigationBar.translucent = NO;
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:venusSelectDetailView animated:YES];
    }
    else if ([buttonName isEqualToString:@"Select"]){
        [paperPreviewImageView setHidden:YES];
        [self moveAnimationRootView:NO];
        [self setHiddenRootItem:NO];
        MainVIewMoved = NO;
        
        //--- 용액 채우는 애니메이션 중 Select 버튼을 누르면 NSTimer가 중단되면서 비이커 레벨 채우는 작업이 중단된다.그래서 아래로 코드로 강제로 비이커 최종레벨로 셋팅한다.
        [beakerView setProgress: wantProgressLevel];
    }
}


#pragma mark -
#pragma mark Touch handling
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
    //NSLog(@"touch = %@", touch);
    
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"point %f, %f", point.x, point.y);
    
	// Only move the placard view if the touch was in the placard view
    if (chemicalAni.chemicalAnimating == NO){
        if (point.x > 65 && point.x < 110 && point.y > 90 && point.y < 200) {
            BOOL isMaxProgress = [beakerView isMaxProgress];
            if (isMaxProgress == NO) {
                chemicalAni.selectedChemicalIndex = chemicalPageControl.currentPage;
                [self fillChemicalAnimation];
                waitBaekerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(fillBaakerProgress) userInfo:nil repeats:NO];
            }
            else {
                [self showBeakerEmptyAlertView];
            }
        }
        if (point.x > 130 && point.x < 180 && point.y > 110 && point.y < 190){
            [self showBeakerEmptyAlertView];
        }
    }
    else if (point.y > 200){
        NSLog(@"select steel touched!");
    }
}

@end

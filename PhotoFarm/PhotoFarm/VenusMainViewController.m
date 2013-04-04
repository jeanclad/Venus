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
            /*
            thumbnailImageRef = [asset thumbnail];
            thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
             */
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
        
        //---   용지가 선택되어 있는 상태에서 사진을 변경하여 선택하였을 경우 그 사진에 다시 용지를 입혀야 한다.
        if (_bg != nil) {
            [self setPaperPreviewImage];
            //result_img = thumbnail;            
            result_img = preview_img;
        }
        
        else{
            //result_img = thumbnail;
            result_img = mainPhotoView;
        }
            
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
        
        ///*/ Photo Save to caches test by jenaclad
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
        //*/
 
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
        
        ///* persist test by jeanclad
        [self loadPlistFile];
        
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


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [GlobalDataManager sharedGlobalDataManager].selectedAssets = nil;
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage = shrinkImage(chosenImage, selectedButton.frame.size);
    //thumbnail = shrunkenImage;
    mainPhotoView = shrunkenImage;
    firstSelect = YES;
    
    [picker dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Alert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"button = %d", buttonIndex);
    
    //---   비이커 비움 alert의 버튼 처리
    if (buttonIndex == 0){
        // set a timer that updates the progress
        wantProgressLevel = 0;
        fillBeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f target: self selector: @selector(updateProgress) userInfo: nil repeats: YES];
        [[NSRunLoop mainRunLoop] addTimer:fillBeakerTimer forMode:NSRunLoopCommonModes];        
        [fillBeakerTimer fire];
        
        stopBeakerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:BEAKER_DROP_WATER_TIME target:self selector:@selector(stopBeakerProgress) userInfo:nil repeats:NO];
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

- (IBAction)UnderButtonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);
    
    NSString *string1 = NSLocalizedString(@"NoPhotoTitle", @"사진 없음 메세지 타이틀");
    NSString *string2 = NSLocalizedString(@"NoPhotoMessage", @"사진 없음 메세지");
    NSString *string3 = NSLocalizedString(@"OK", "확인");
    
    if ([buttonName isEqualToString:@"Album"]){
        VenusAlbumPageViewController *venusAlbumPageView = [[VenusAlbumPageViewController alloc] initWithNibName:@"VenusAlbumPageViewController" bundle:nil];
        venusAlbumPageView.rootNaviController = self.navigationController;
        
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor clearColor];
        self.navigationController.navigationBar.translucent = YES;
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:venusAlbumPageView animated:YES];
    }
    else if ([buttonName isEqualToString:@"Papers"]){
        if (firstSelect == YES){
            [self moveAnimationRootView:YES];
            [self setHiddenRootItem:YES];
            
            [paperScrollView setHidden:NO];
            [paperPageControl setHidden:NO];
            [chemicalScrollView setHidden:YES];
            [chemicalPageControl setHidden:YES];
            [beakerView setHidden:YES];
            MainVIewMoved = YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([buttonName isEqualToString:@"Chemicals"]){
        if (firstSelect == YES){
            [self moveAnimationRootView:YES];
            [self setHiddenRootItem:YES];
            
            [paperScrollView setHidden:YES];
            [paperPageControl setHidden:YES];
            [chemicalScrollView setHidden:NO];
            [chemicalPageControl setHidden:NO];
            [beakerView setHidden:NO];
            MainVIewMoved = YES;
        
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

- (void)moveAnimationRootView:(BOOL)move
{
    if (move == YES){
        [selectedButton setUserInteractionEnabled:NO];
        //[self setAnimationRootViewRight];
        [self setMainSecondView];
    }
    else{
        //[self setAnimationRootViewLeft];
        [selectedButton setUserInteractionEnabled:YES];
        [self setMainView];
    }
}

/*
- (void)setAnimationRootViewRight
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    float delay = 0;
    
    [UIView beginAnimations:@"pincetteUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelay:delay];        
    [UIView setAnimationDelegate:self];
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x + PINCETTE_MOVE_X, self.pincetteImage.frame.origin.y - PINCETTE_MOVE_Y, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [UIView commitAnimations];
    
    //---   핀셋과 사진이 내려가는 SEL함수가 실행되야 하므로 delay는 2배가 되어야 한다.
    delay += MAINVIEW_ANIMATION_DELAY;
    delay += MAINVIEW_ANIMATION_DELAY;    
    
    [UIView beginAnimations:@"MainViewRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:self];
    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x + moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)setAnimationRootViewLeft
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    float delay = 0;
    
    [UIView beginAnimations:@"MainViewLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDelegate:self];
    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x - moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    
    [UIView commitAnimations];
    delay += MAINVIEW_ANIMATION_DELAY;
    
    [UIView beginAnimations:@"PhotoUp" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:self];   
    selectedButton.frame = CGRectMake(selectedButton.frame.origin.x, selectedButton.frame.origin.y - SELECTED_BUTTON_MOVE_Y, selectedButton.frame.size.width, selectedButton.frame.size.height);
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x, self.pincetteImage.frame.origin.y - PINCETTE_MOVE_Y, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [UIView commitAnimations];
}

- (void)pincetteAndPhotoDownAnimation:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [UIView beginAnimations:@"PincettePhotoDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    selectedButton.frame = CGRectMake(selectedButton.frame.origin.x, selectedButton.frame.origin.y + SELECTED_BUTTON_MOVE_Y, selectedButton.frame.size.width, selectedButton.frame.size.height);
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x, self.pincetteImage.frame.origin.y + PINCETTE_MOVE_Y, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)pincetteDownAnimation:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [UIView beginAnimations:@"PincetteDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x - PINCETTE_MOVE_X, self.pincetteImage.frame.origin.y + PINCETTE_MOVE_Y, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    
    [UIView commitAnimations];
}
 */

-(void)setMainView
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float w,h;
    
    if (screen.bounds.size.height== 568) {
        w = 568;
        h = 320;
    }else{
        w = 480;
        h = 320;
    }
    
    self.pincetteImage.frame = CGRectMake(40, 210, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    selectedButton.frame = CGRectMake(w/2-70, h/2-90, PREVIEW_NO_MOVE_FRAME_SIZE_WIDTH, PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT);
    
    [UIView beginAnimations:@"BigSteelHide" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.MainView
                             cache:NO];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2]
    ;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(mainViewAnmiationDone:finished:context:)];
    [self.MainSecondView setHidden:YES];
    [UIView commitAnimations];
}


-(void)setMainSecondView
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    [UIView beginAnimations:@"MainViewRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(mainSecondViewAnmiationDone:finished:context:)];
    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x + moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    [UIView commitAnimations];
}

- (void)mainSecondViewAnmiationDone:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    float delay = 0;
    
    [UIView beginAnimations:@"BigSteelShow" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.MainView
                             cache:NO];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*2];
    [self.MainSecondView setHidden:NO];
    [UIView commitAnimations];
    
    delay += MAINVIEW_ANIMATION_DELAY*2;

    selectedButton.frame = CGRectMake(0, -170, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
    [selectedButton setAlpha:0];
    
    self.pincetteImage.frame = CGRectMake(0, -30, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [self.pincetteImage setAlpha:0];
    
    [UIView beginAnimations:@"PhotoDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*3];
    [UIView setAnimationDelay:delay];
    selectedButton.frame = CGRectMake(SELECT_BUTTON_MOVE_X_IP4, SELECT_BUTTON_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
    [selectedButton setAlpha:1];
    self.pincetteImage.frame = CGRectMake(0, 200, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
    [self.pincetteImage setAlpha:1];
    [UIView commitAnimations];
}

- (void)mainViewAnmiationDone:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    [UIView beginAnimations:@"MainViewRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION];
    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x - moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    [UIView commitAnimations];
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
        [UIView setAnimationDuration:MAINVIEW_ANIMATION_DURATION*3];
        [UIView setAnimationDelay:0.5f];
        [selectedButton setAlpha:1.0];

        [UIView commitAnimations];
    //---   ChemicalView
    } else{
        ;
    }    
}

- (void)setPaperPreviewImage
{
    NSLog(@"paperPagecontrol.currentPage = %d", paperPageControl.currentPage);
    
    // currentPage가 0일때는 no page 일때 이므로 이때는 Paper와 합성을 하지 않고 원본 사진 이미지만 표시하게 한다.
    if (paperPageControl.currentPage != 0){
        //get character image
        //UIImage *_character = thumbnail;
        UIImage *_character = mainPhotoView;
        _bg = [UIImage imageNamed:[NSString stringWithFormat:@"paper_preview_%d.png", paperPageControl.currentPage]];
        if (_bg != nil) {
            UIGraphicsBeginImageContext(_bg.size);
            if ([paperPageControl currentPage] == PAPER_INDEX_POLARIOD){
                [_bg drawInRect:CGRectMake(0, 0, PREVIEW_POLAROID_FRAME_SIZE_WIDTH, PREVIEW_POLAROID_FRAME_SIZE_HEIGHT)];
                [_character drawInRect:CGRectMake(PREVIEW_POLAROID_PHOTO_ORIGIN_X, PREVIEW_POLAROID_PHOTO_ORIGIN_Y, PREVIEW_POLAROID_PHOTO_SIZE_WIDTH, PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT)];
                preview_img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }else if([paperPageControl currentPage] == PAPER_INDEX_ROLLED_UP){
                [_bg drawInRect:CGRectMake(0, 0, PREVIEW_ROLLED_UP_FRAME_SIZE_WIDTH, PREVIEW_ROLLED_UP_FRAME_SIZE_HEIGHT)];
                [_character drawInRect:CGRectMake(PREVIEW_ROLLED_UP_PHOTO_ORIGIN_X, PREVIEW_ROLLED_UP_PHOTO_ORIGIN_Y, PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH, PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT)];
                preview_img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }else if ([paperPageControl currentPage] == PAPER_INDeX_SPRING){
                [_bg drawInRect:CGRectMake(0, 0, PREVIEW_SPRING_FRAME_SIZE_WIDTH, PREVIEW_SPRING_FRAME_SIZE_HEIGHT)];
                [_character drawInRect:CGRectMake(PREVIEW_SPRING_PHOTO_ORIGIN_X, PREVIEW_SPRING_PHOTO_ORIGIN_Y, PREVIEW_SPRING_PHOTO_SIZE_WIDTH, PREVIEW_SPRING_PHOTO_SIZE_HEIGHT)];
                preview_img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }else if ([paperPageControl currentPage] == PAPER_INDEX_VINTAGE){
                [_bg drawInRect:CGRectMake(0, 0, PREVIEW_VINTAGE_FRAME_SIZE_WIDTH, PREVIEW_VINTAGE_FRAME_SIZE_HEIGHT)];
                [_character drawInRect:CGRectMake(PREVIEW_VINTAGE_PHOTO_ORIGIN_X, PREVIEW_VINTAGE_PHOTO_ORIGIN_Y, PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH, PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
                preview_img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }else{
                [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
                [_character drawInRect:CGRectMake(PREVIEW_ORIGIN_X, PREVIEW_ORIGIN_Y, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
                preview_img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    } else{
        preview_img = mainPhotoView;
    }
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

- (void) fillChemicalAnimation
{
    int chemicalRotationAngle = CHEMICAL_ROTATION_ANGLE;
    
    [chemicalAni setChemicalAniDuration];
    
    //---   Will edit position
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
                NSLog(@"666");
                currentProgress += (0.01f * progressDir);
                [beakerView setProgress: currentProgress];
            }
            
        } else if (wantProgressLevel > currentProgress){
            if (currentProgress < wantProgressLevel){
                NSLog(@"5555");
                currentProgress += (0.01f * progressDir);
                [beakerView setProgress: currentProgress];
            }
        }
    }
    
    NSLog(@"wantProgress = %f, 1 currentProgress = %f", wantProgressLevel, currentProgress);
}

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
        //if (([touch view] == chemicalScrollView) || ([touch view] == chemicalContentView)) {
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

//
//  VenusMainViewController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusMainViewController.h"
#import "GlobalDataManager.h"
#import "VenusFilmGroupViewController.h"
#import "VenusAlbumPageViewController.h"
#import "VenusSelectDetailViewController.h"
/* persist test by jeanclad
#import "VenusPersistList.h"
*/

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
    paperScrollView = [[UIScrollView alloc]
				  initWithFrame:CGRectMake(0, 0, 240, 290)];
	
	paperContentView = [[UIView alloc] initWithFrame:CGRectMake(75, 90, 240, 1740)];
    int paperTotal = 0;
    
    for (int i = 0; i < 6; i++) {
		CGRect imageViewFrame;
		imageViewFrame = CGRectMake(0, paperTotal, 90, 100);
		paperTotal = paperTotal + 290;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		UIImage *image = [UIImage imageNamed:
						  [NSString stringWithFormat:@"select_box%d.png", (i+1)]];
        imageView.image = image;
		[paperContentView addSubview:imageView];
	}
	
	[paperScrollView addSubview:paperContentView];
	paperScrollView.contentSize = paperContentView.frame.size;
	[self.selectView addSubview:paperScrollView];
	paperScrollView.pagingEnabled = YES;;
    paperScrollView.showsHorizontalScrollIndicator = NO;
    paperScrollView.showsVerticalScrollIndicator = NO;
	
	paperPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(1000, 1000, 80, 36)];
	paperPageControl.currentPage = 0;
	paperPageControl.numberOfPages = 6;
	[paperPageControl addTarget:self action:@selector(paperPageChangeValue:) forControlEvents:UIControlEventValueChanged];
	[self.selectView addSubview:paperPageControl];
	paperScrollView.delegate = self;
    
    
    chemicalScrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0, 0, 240, 290)];
	
	chemicalContentView = [[UIView alloc] initWithFrame:CGRectMake(65, 90, 240, 2610)];
    int chemicalTotal = 0;
    
    for (int i = 0; i < 9; i++) {
		CGRect imageViewFrame;
		imageViewFrame = CGRectMake(0, chemicalTotal, 50, 100);
		chemicalTotal = chemicalTotal + 290;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		UIImage *image = [UIImage imageNamed:
						  [NSString stringWithFormat:@"select_solution0%d.png", (i+1)]];
        imageView.image = image;
		[chemicalContentView addSubview:imageView];
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
    
    
    //---   큰 사짓 밧드 이미지 숨기기
    [self.bigSteelImage setHidden:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
    MainVIewMoved = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        if (asset != nil){
            thumbnailImageRef = [asset thumbnail];
            thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        }
        
        UIImage * result_img;
        if (_bg != nil) {
            result_img = preview_img;
        }
        else{
            result_img = thumbnail;
        }
        [selectedButton setBackgroundImage:result_img forState:UIControlStateNormal];
        
        selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        selectButton.frame = CGRectMake(200, 200, 67, 67);
        if (MainVIewMoved == NO)
            selectedButton.frame = CGRectMake(w/2-80, h/2-86, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
        else
            selectedButton.frame = CGRectMake((w/2-80) + moveXpos - 50, (h/2-86) + SELECT_RIGHT_MOVE_Y, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT);
        
        [selectedButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectedButton];
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
        [self.view addSubview:selectedButton];
        
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
    [self setBeakerImage:nil];
    [self setBigSteelImage:nil];
    [self setSmallSteelImage:nil];
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
    thumbnail = shrunkenImage;
    firstSelect = YES;
    
    [picker dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
        //if (firstSelect == YES){
            [self moveAnimationRootView:YES];
            [self setHiddenRootItem:YES];
            
            [paperScrollView setHidden:NO];
            [paperPageControl setHidden:NO];
            [chemicalScrollView setHidden:YES];
            [chemicalPageControl setHidden:YES];
            [self.beakerImage setHidden:YES];
            MainVIewMoved = YES;
        //}else{
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            //[alert show];
        //}
    }
    else if ([buttonName isEqualToString:@"Chemicals"]){
        //if (firstSelect == YES){
            [self moveAnimationRootView:YES];
            [self setHiddenRootItem:YES];
            
            [paperScrollView setHidden:YES];
            [paperPageControl setHidden:YES];
            [chemicalScrollView setHidden:NO];
            [chemicalPageControl setHidden:NO];
            [self.beakerImage setHidden:NO];
            MainVIewMoved = YES;        
        //} else {
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            //[alert show];
        ///}
    }
    else if ([buttonName isEqualToString:@"Info"]){
        VenusSelectDetailViewController *venusSelectDetailView = [[VenusSelectDetailViewController alloc] initWithNibName:@"VenusSelectDetailViewController" bundle:nil];

        if (paperScrollView.isHidden == YES){
            [venusSelectDetailView setItemValue:ITEM_VALUE_CHEMICAL];
            [venusSelectDetailView setCurrentItem:[chemicalPageControl currentPage]];
        }
        else{
            [venusSelectDetailView setItemValue:ITEM_VALUE_PAPER];
            [venusSelectDetailView setCurrentItem:[paperPageControl currentPage]];
        }
        
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        self.navigationController.navigationBar.translucent = NO;
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:venusSelectDetailView animated:YES];
    }
    else if ([buttonName isEqualToString:@"Reset"]){
        
    }
    else if ([buttonName isEqualToString:@"Select"]){
        [self moveAnimationRootView:NO];
        [self setHiddenRootItem:NO];
         MainVIewMoved = NO;
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
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height== 568)
        moveXpos = 284;
    else
        moveXpos = 240;
    
    [self.bigSteelImage setHidden:NO];
    [self.smallSteelImage setHidden:NO];
    
    if (move == YES){
        [selectedButton setUserInteractionEnabled:NO];
        
        [UIView beginAnimations:@"pincetteUp" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moveAnimationRootViewRight:finished:context:)];
        self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x + 50, self.pincetteImage.frame.origin.y - 100, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
        [UIView commitAnimations];
    }
    else{
        [selectedButton setUserInteractionEnabled:YES];
        
        [UIView beginAnimations:@"pincetteUp" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moveAnimationRootViewLeft:finished:context:)];
        self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x, self.pincetteImage.frame.origin.y - 100, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);
        selectedButton.frame = CGRectMake(selectedButton.frame.origin.x, selectedButton.frame.origin.y - 45, selectedButton.frame.size.width, selectedButton.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)moveAnimationRootViewRight:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height == 568)
        moveXpos = SELECT_RIGHT_MOVE_X_IP5;
    else
        moveXpos = SELECT_RIGHT_MOVE_X_IP4;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x + moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    selectedButton.frame = CGRectMake(selectedButton.frame.origin.x + moveXpos - 50, selectedButton.frame.origin.y + 45, selectedButton.frame.size.width, selectedButton.frame.size.height);
    
    self.smallSteelImage.frame = CGRectMake(self.smallSteelImage.frame.origin.x + 200, self.smallSteelImage.frame.origin.y, self.smallSteelImage.frame.size.width, self.smallSteelImage.frame.size.height);
    self.bigSteelImage.frame = CGRectMake(self.bigSteelImage.frame.origin.x - 450, self.bigSteelImage.frame.origin.y, self.bigSteelImage.frame.size.width, self.bigSteelImage.frame.size.height);
    
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x - 50, self.pincetteImage.frame.origin.y + 100, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);

    [UIView commitAnimations];

}

- (void)moveAnimationRootViewLeft:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float moveXpos;
    
    if (screen.bounds.size.height== 568)
        moveXpos = 284;
    else
        moveXpos = 240;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];

    self.MainView.frame = CGRectMake(self.MainView.frame.origin.x - moveXpos, self.MainView.frame.origin.y, self.MainView.frame.size.width, self.MainView.frame.size.height);
    selectedButton.frame = CGRectMake(selectedButton.frame.origin.x - moveXpos + 50, selectedButton.frame.origin.y, selectedButton.frame.size.width, selectedButton.frame.size.height);
    
    self.bigSteelImage.frame = CGRectMake(self.bigSteelImage.frame.origin.x + 450, self.bigSteelImage.frame.origin.y, self.bigSteelImage.frame.size.width, self.bigSteelImage.frame.size.height);
    self.smallSteelImage.frame = CGRectMake(self.smallSteelImage.frame.origin.x  - 200, self                                 .smallSteelImage.frame.origin.y, self.smallSteelImage.frame.size.width, self.smallSteelImage.frame.size.height);
    
    self.pincetteImage.frame = CGRectMake(self.pincetteImage.frame.origin.x, self.pincetteImage.frame.origin.y + 100, self.pincetteImage.frame.size.width, self.pincetteImage.frame.size.height);

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
        paperPageControl.currentPage = floor((paperScrollView.contentOffset.y - pageHeight / 6) / pageHeight) + 1;
    }
    else if (sender == chemicalScrollView){
        CGFloat pageHeight = paperScrollView.frame.size.height;
        chemicalPageControl.currentPage = floor((chemicalScrollView.contentOffset.y - pageHeight / 9) / pageHeight) + 1;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == paperScrollView){
        //get character image
        UIImage *_character = thumbnail;
        _bg = [UIImage imageNamed:[NSString stringWithFormat:@"paper_preview_%d.png", paperPageControl.currentPage]];
        //NSLog(@"bg_size : %f, %f", _bg.size.width, _bg.size.height);
        if (_bg != nil) {
            UIGraphicsBeginImageContext(_bg.size);
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            NSLog(@"_character = %f, %f", _character.size.width, _character.size.height);
            [_character drawInRect:CGRectMake(5, 5, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT)];
            preview_img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    } else{
        
    }
    
}
@end

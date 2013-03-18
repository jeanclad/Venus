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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController setNavigationBarHidden:YES];
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
    
    ///* persist test by jeanclad
    photoInfoFileList = [[VenusPersistList alloc] init];
    [photoInfoFileList initPlistData];
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
        selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        selectButton.frame = CGRectMake(200, 200, 67, 67);
        selectedButton.frame = CGRectMake(w/2-43, h/2-86, 134, 134);
        [selectedButton setBackgroundImage:thumbnail forState:UIControlStateNormal];
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

        ///*/ Photo Load to caches test by jenaclad
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * path = [documentsDirectory stringByAppendingPathComponent:@"Venus_Paperless_2.png"];
        NSData * loadImageData = [NSData dataWithContentsOfFile:path];
        
        UIImage *testImage = [UIImage imageWithData:loadImageData];
        UIImageView *testImageView = [[UIImageView alloc] init];
        [testImageView setFrame:CGRectMake(0, 0, 300, 300)];
        [testImageView setImage:testImage];
        [self.view addSubview:testImageView];
        
        [photoInfoFileList setPhotoItemName:@"Venus2"];
        [photoInfoFileList setPaperPhotoFileName:@"Venus_Paper_2.png"];
        [photoInfoFileList setPaperlessPhotoFileName:@"Venus_Paperless_2.png"];
        [photoInfoFileList setPaperType:[NSNumber numberWithInt:PAPER_TYPE_CRUMPLED]];
        [photoInfoFileList setChemicalType:[NSNumber numberWithInt:CHEMICAL_TYPE_1620]];
        
        [photoInfoFileList fillPlistData];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                     initForWritingWithMutableData:data];
        [archiver encodeObject:photoInfoFileList forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
        
        NSLog(@"persistList_load = %@", photoInfoFileList.persistList);
    } else {
        NSLog(@"ccc");
        selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectedButton.frame = CGRectMake(w/2-100, h/2-38, 200, 76);
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
    
    if ([buttonName isEqualToString:@"Album"]){
        VenusAlbumPageViewController *venusAlbumPageView = [[VenusAlbumPageViewController alloc] initWithNibName:@"VenusAlbumPageViewController" bundle:nil];
        venusAlbumPageView.photoInfoList = [[VenusPersistList alloc] init];
        venusAlbumPageView.photoInfoList = photoInfoFileList;
        venusAlbumPageView.reversePlistKeys = reversePlistKeys;
        
        venusAlbumPageView.rootNaviController = self.navigationController;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:venusAlbumPageView animated:YES];
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
        photoInfoFileList = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        //NSLog(@"loadPlist = %@ count = %d", loadPersistList.persistList, loadPersistList.persistList.count);
        //--------------------------------------------------------------------------------------------------
        
        
        //---   plist를 맨 마지막 저장된 것이 맨 처음 인덱스로 오도록 역순으로 sorting 한다.
        NSArray *allKeys = [[NSArray alloc] initWithArray:[photoInfoFileList.persistList allKeys]];
        NSLog(@"Allkeys = %@", allKeys);
        
        NSArray *tmpArray = [[NSArray alloc] initWithArray:allKeys];
        
        tmpArray = [allKeys sortedArrayUsingSelector:@selector(compare:)];
        //NSLog(@"sort = %@", tmpArray);
        
        NSEnumerator *enumReverse = [tmpArray reverseObjectEnumerator];
        NSString *tmpString;
        
        reversePlistKeys = [[NSMutableArray alloc] init];
        
        while(tmpString = [enumReverse nextObject]){
            //NSLog(@"tmpString = %@", tmpString);
            [reversePlistKeys addObject:tmpString];
        }
        
        NSLog(@"dictAllKeys = %@", reversePlistKeys);
        
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
@end

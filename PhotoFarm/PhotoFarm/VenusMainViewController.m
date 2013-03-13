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
    
    // Will Edit to button position

    [self setAsset:(ALAsset *)[GlobalDataManager sharedGlobalDataManager].selectedAssets];

    if ((asset != nil) || (firstSelect == YES)){
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
        
        /*/ test by jenaclad
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * cachesDirectory = [paths objectAtIndex:0];
        NSString * filePath = [cachesDirectory stringByAppendingPathComponent:@"screenshot4.png"];
        UIImage * image = fullScreenImage;
        NSData * saveImageData = UIImagePNGRepresentation(image);
        [saveImageData writeToFile:filePath atomically:NO];

        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * path = [documentsDirectory stringByAppendingPathComponent:@"screenshot.png"];
        NSData * loadImageData = [NSData dataWithContentsOfFile:path];
        
        UIImage *testImage = [UIImage imageWithData:loadImageData];
        UIImageView *testImageView = [[UIImageView alloc] init];
        [testImageView setFrame:CGRectMake(0, 0, 300, 300)];
        [testImageView setImage:testImage];
        [self.view addSubview:testImageView];
         */
         

    } else {
        selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectedButton.frame = CGRectMake(w/2-100, h/2-38, 200, 76);
        [selectedButton setTitle:@"Select to image" forState:UIControlStateNormal];
        [selectedButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectedButton];
        
        /* test by jeanclad
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
    
    /*
     VenusFilmGroupViewController *VenusFilmGroupView = [[VenusFilmGroupViewController alloc] initWithNibName:@"VenusFilmGroupViewController" bundle:nil];
     [self.navigationController pushViewController:VenusFilmGroupView animated:YES];
     */
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


/*
static CGImageRef shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale,
                                                 size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, size.width * scale, size.height * scale),
                       original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
//    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return shrunken;
}
 */

- (IBAction)UnderButtonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);
    
    if ([buttonName isEqualToString:@"Album"]){
        VenusAlbumPageViewController *VenusAlbumPageView= [[VenusAlbumPageViewController alloc] initWithNibName:@"VenusAlbumPageViewController" bundle:nil];
        VenusAlbumPageView.rootNaviController = self.navigationController;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:VenusAlbumPageView animated:YES];
    }
}
@end

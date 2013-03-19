//
//  VenusAlbumDetailViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "GlobalDataManager.h"
#import "VenusAlbumDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VenusAlbumDetailViewController ()

@end

@implementation VenusAlbumDetailViewController
@synthesize loadImage;

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
    
    indicatorView = nil;
    
    //---   저장된 파일을 로딩한다.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesDirectory = [paths objectAtIndex:0];
    NSString *fileName = [[[GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList objectForKey:self.selectedKey] objectAtIndex:INDEX_PAPERLESS_PHOTO_FILE_NAME];
    NSString * path = [cachesDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"load path = %@", path);
    NSData * loadImageData = [NSData dataWithContentsOfFile:path];
    
    /* File Read test by jeanclad
    NSError *error = nil;
    NSData * loadImageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:&error];
    NSLog(@"error = %@", error.localizedDescription);
    */
    
    //----- 넘어온 이미지를 화면에 표시하고 라벨 뷰는 숨긴다.
    loadImage = [[UIImage alloc] initWithData:loadImageData];
//    loadImage = [UIImage imageWithData:loadImageData];

    [self.detailPageLabelView setHidden:YES];
    [self.detailPagePhotoVIew setImage:loadImage];
    //----------------------------------------
    
    //  제스쳐 설정 (페이지뷰 컨틀로러가 좌/우측 탭만 하여도 넘어가기 때문에 텝 이벤트를 오버라이딩하여
    //  네비게이션 바를 숨기고 보이는 용도로 사용함
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onSingleTap:)];

    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDetailPagePhotoVIew:nil];
    [self setDetailPageLabelView:nil];
    [self setDetailContentView:nil];
    [super viewDidUnload];
}


#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList removeObjectForKey:self.selectedKey];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                     initForWritingWithMutableData:data];
        [archiver encodeObject:[GlobalDataManager sharedGlobalDataManager].photoInfoFileList forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
        
        [[GlobalDataManager sharedGlobalDataManager].reversePlistKeys removeObject:self.selectedKey];
        // Will Edited by jeanclad
        // 이 부분에서 차후 사진 파일도 삭제해야 한다.
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@ : persist", [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList]);
    }
}


#pragma mark jeanclad
- (IBAction)buttonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);

    if ([buttonName isEqualToString:@"Save"]){
        // 파일 저장용 인디케이터 설정
        [self performSelector:@selector(showIndicatorView) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        
        // 이미지에 메타 정보를 기록하고, 저장
        //---   이미지를 SEL 형식으로 저장 test by jeanclad
        //UIImageWriteToSavedPhotosAlbum(loadImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        //-----------------------------------------------
       
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

        [library writeImageToSavedPhotosAlbum:[loadImage CGImage] orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
            [indicatorView stopAnimating];
            
            NSString *string1;
            NSString *string2;
            NSString *string3;
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                string1 = NSLocalizedString(@"PhotoSavedTitle", @"사진 저장 타이틀");
                string2 = NSLocalizedString(@"PhotoSavedErrMessage", @"사진 저장 실패 메세지 ");
                string3 = NSLocalizedString(@"Cancle", @"취소");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"Saved Photo");
                string1 = NSLocalizedString(@"PhotoSavedTitle", @"사진 저장 타이틀");
                string2 = NSLocalizedString(@"PhotoSavedDoneMessage", @"사진 저장 완료 메세지 ");
                string3 = NSLocalizedString(@"Done", @"완료");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else if ([buttonName isEqualToString:@"Delete"]){
        NSString *title = NSLocalizedString(@"PhotoDeleteTitle", @"사진 삭제 메세지 타이틀");
        NSString *string1 = NSLocalizedString(@"Cancel", @"취소");
        NSString *string2 = NSLocalizedString(@"Delete", @"삭제");
        
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:string1 destructiveButtonTitle:string2 otherButtonTitles:nil, nil];
        
        [actionsheet showInView:self.view];
        
    } else if ([buttonName isEqualToString:@"Info"]){
        if ([self.detailPagePhotoVIew isHidden]){
            [self.detailPagePhotoVIew setHidden:NO];
            [self.detailPageLabelView setHidden:YES];
        } else {
            [self.detailPagePhotoVIew setHidden:YES];
            [self.detailPageLabelView setHidden:NO];
        }
        
        // 네비게이션 스택 Push에 transition animation
        [UIView beginAnimations:@"anotheranimation" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.DetailContentView
                                 cache:NO];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
    } else if ([buttonName isEqualToString:@"Sns"]){
     
    }
}

- (void) onSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"gestureRecognizer: %d",gestureRecognizer.view.tag);
    
    if (self.navigationController.isNavigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void) showIndicatorView
{   	
    // Will Edit 좌표
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setFrame:CGRectMake(20.0f, 20.0f, 200.0f, 200.0f)];
        [indicatorView setHidesWhenStopped:YES];
        //[indicatorView setBackgroundColor:[UIColor grayColor]];

        [self.view addSubview:indicatorView];
    }
    [self.view bringSubviewToFront:indicatorView];
    [indicatorView startAnimating];
}

/*
//---   이미지를 SEL 형식으로 저장 test by jeanclad
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}
*/

@end

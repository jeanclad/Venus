//
//  VenusAlbumDetailViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusAlbumDetailViewController.h"
#import "VenusPersistList.h"

@interface VenusAlbumDetailViewController ()

@end

@implementation VenusAlbumDetailViewController

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
    NSLog(@"plist = %@", self.currentPagePlistData);
    
    //---   저장된 파일을 로딩한다.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesDirectory = [paths objectAtIndex:0];
    NSString * path = [cachesDirectory stringByAppendingPathComponent:[self.currentPagePlistData objectAtIndex:INDEX_PAPERLESS_PHOTO_FILE_NAME]];
    NSLog(@"load path = %@", path);
    NSData * loadImageData = [NSData dataWithContentsOfFile:path];
    
    /* File Read test by jeanclad
    NSError *error = nil;
    NSData * loadImageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:&error];
    NSLog(@"error = %@", error.localizedDescription);
    */
    
    //----- 넘어온 이미지를 화면에 표시하고 라벨 뷰는 숨긴다.
    UIImage *loadImage = [UIImage imageWithData:loadImageData];
    [self.detailPagePhotoVIew setImage:loadImage];
    [self.detailPageLabelView setHidden:YES];
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


#pragma mark jeanclad
- (IBAction)buttonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);
    
    if ([buttonName isEqualToString:@"Save"]){
        
    } else if ([buttonName isEqualToString:@"Delete"]){
        
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

@end

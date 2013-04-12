//
//  VenusPhotoPaperController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 4. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenusPhotoPaperController : NSObject

//---   원본 이미지
@property (nonatomic, retain) UIImage   *orgPhotoImage;

//---   mainView의 SelectedButton에 사용될 사진+용지 이미지 (140*140)
@property (nonatomic, retain) UIImage   *mainPreviewPhotoImage;

//---   암실뷰, mainSecondView에 사용될 사진,용지 이미지 (200*200)
@property (nonatomic, retain) UIImage   *mainSecondPreviewPaperImage;
@property (nonatomic, retain) UIImage   *mainSecondPreviewPhotoImage;

//---   앨범뷰에 사용될 사진+용지 이미지 (200*200)
@property (nonatomic, retain) UIImage   *albumPaperPhotoImage;
//---   앨범뷰에 사용될 사진 이미지 (320*320)
@property (nonatomic, retain) UIImage   *albumPaperlessPhotoImage;

- (BOOL)isPaperTopLayer:(NSInteger)currentPage;
- (CGFloat)getDevelopingPaperAlpha:(NSInteger)currentPage;
- (void)fillImageItem:(UIImage *)refImage currentPage:(NSInteger)currentPage;
- (void)changePaperToImageItem:(NSInteger)currentPage;

@end

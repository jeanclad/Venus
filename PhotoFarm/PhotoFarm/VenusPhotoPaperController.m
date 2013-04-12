//
//  VenusPhotoPaperController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 4. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusPhotoPaperController.h"
#import "VenusPersistList.h"
#import "VenusMainViewController.h"

@implementation VenusPhotoPaperController
- (void)changePaperToImageItem:(NSInteger)currentPage
{
    //---   앨범뷰에 사용될 이미지를 먼저 생성한후 그 이미지를 리사이징 하여 MainView에 사용될 이미지를 만든다.
    [self makeAlbumPaperAndPaperlessPhotoImage:_orgPhotoImage currentPage:currentPage];
    [self makeMainPreviewPhotoImage];
    [self makeMainSecondPreViwePaperAndPaperlessPhotoImage:_orgPhotoImage currentPage:currentPage];
}

- (void)fillImageItem:(UIImage *)refImage currentPage:(NSInteger)currentPage
{
    _orgPhotoImage = refImage;
    
    //---   앨범뷰에 사용될 이미지를 먼저 생성한후 그 이미지를 리사이징 하여 MainView에 사용될 이미지를 만든다.
    [self makeAlbumPaperAndPaperlessPhotoImage:refImage currentPage:currentPage];
    [self makeMainPreviewPhotoImage];
    [self makeMainSecondPreViwePaperAndPaperlessPhotoImage:refImage currentPage:currentPage];
}

- (void)makeMainPreviewPhotoImage
{
    //---   앨범뷰에 사용될 사진+용지 이미지 (200*200)를 (140*140)으로 리사이징만 한다.
    _mainPreviewPhotoImage = [self makeThumbnailImage:_albumPaperPhotoImage onlyCrop:NO Size:PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT];
}

- (void)makeMainSecondPreViwePaperAndPaperlessPhotoImage:(UIImage *)refImage currentPage:(NSInteger)currentPage
{
    //---   암실뷰, mainSecondView에 사용될 용지 이미지 (200*200)
    _mainSecondPreviewPaperImage = [UIImage imageNamed:[NSString stringWithFormat:@"paper_preview_%d.png", currentPage]];
    [_mainSecondPreviewPaperImage drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
    
    //---   암실뷰, mainSecondView에 사용될 사진 이미지 (200*200) / 용지에 따라 사진의 시작점과 사이즈가 약간씩 다르다.
    CGSize photoSize = [self getDevelopingPhotoSize:currentPage];
    _mainSecondPreviewPhotoImage = [self makeThumbnailImage:refImage onlyCrop:NO Size:photoSize.height];
}

- (void)makeAlbumPaperAndPaperlessPhotoImage:(UIImage *)refImage currentPage:(NSInteger)currentPage
{
    //---   앨범뷰에 사용될 사진+용지 이미지 (200*200)
    UIImage *resizePhotoImage = [self makeThumbnailImage:refImage onlyCrop:NO Size:PREVIEW_FRAME_SIZE_HEIGHT];
    [self setAlbumPaperImage:resizePhotoImage currentPage:currentPage];
    
    //---   앨범뷰에 사용될 사진 이미지 (320*320)
    _albumPaperlessPhotoImage = [self makeThumbnailImage:refImage onlyCrop:NO Size:PAPERLESS_PHOTO_SIZE];
}

- (void)setAlbumPaperImage:(UIImage *)refImage currentPage:(NSInteger)currentPage
{
    //get character image
    UIImage *_bg = [UIImage imageNamed:[NSString stringWithFormat:@"paper_preview_%d.png", currentPage]];
    if (_bg != nil) {
        UIGraphicsBeginImageContext(_bg.size);
        if (currentPage == PAPER_INDEX_WHITE){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_ORIGIN_X, PREVIEW_ORIGIN_Y, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        else if (currentPage == PAPER_INDEX_POLARIOD){
            _bg = [UIImage imageNamed:@"paper_preview_0.png"];
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_POLAROID_PHOTO_ORIGIN_X, PREVIEW_POLAROID_PHOTO_ORIGIN_Y, PREVIEW_POLAROID_PHOTO_SIZE_WIDTH, PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT)];
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if(currentPage == PAPER_INDEX_ROLLED_UP){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_ROLLED_UP_PHOTO_ORIGIN_X, PREVIEW_ROLLED_UP_PHOTO_ORIGIN_Y, PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH, PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT)];
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if (currentPage == PAPER_INDEX_SPRING){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_SPRING_PHOTO_ORIGIN_X, PREVIEW_SPRING_PHOTO_ORIGIN_Y, PREVIEW_SPRING_PHOTO_SIZE_WIDTH, PREVIEW_SPRING_PHOTO_SIZE_HEIGHT)];
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else if (currentPage == PAPER_INDEX_VINTAGE){
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_VINTAGE_PHOTO_ORIGIN_X, PREVIEW_VINTAGE_PHOTO_ORIGIN_Y, PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH, PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];            
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            [_bg drawInRect:CGRectMake(0, 0, PREVIEW_FRAME_SIZE_WIDTH, PREVIEW_FRAME_SIZE_HEIGHT)];
            [refImage drawInRect:CGRectMake(PREVIEW_ORIGIN_X, PREVIEW_ORIGIN_Y, PREVIEW_PHOTO_SIZE_WIDTH, PREVIEW_PHOTO_SIZE_HEIGHT) blendMode:kCGBlendModeMultiply alpha:1.0];
            _albumPaperPhotoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}


- (BOOL)isPaperTopLayer:(NSInteger)currentPage
{
    switch (currentPage) {
        case PAPER_INDEX_WHITE:
        case PAPER_INDEX_POLARIOD:
        case PAPER_INDEX_ROLLED_UP:
        case PAPER_INDEX_SPRING:
        case PAPER_INDEX_VINTAGE:
            return NO;
        case PAPER_INDEX_FOLDED:
        case PAPER_INDEX_CRUMPLED:
            return YES;
        default:
            return NO;
    }
}

- (CGSize)getDevelopingPhotoSize:(NSInteger)currentPage
{
    CGSize photoSize;
    
    if (currentPage == PAPER_INDEX_WHITE){
        photoSize.width = PREVIEW_NOT_PAPER_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_NOT_PAPER_PHOTO_SIZE_HEIGHT;
    }else if (currentPage == PAPER_INDEX_POLARIOD){
        photoSize.width = PREVIEW_POLAROID_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT;
    }else if(currentPage == PAPER_INDEX_ROLLED_UP){
        photoSize.width = PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT;
    }else if (currentPage == PAPER_INDEX_SPRING){
        photoSize.width = PREVIEW_SPRING_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_SPRING_PHOTO_SIZE_HEIGHT;
    }else if (currentPage == PAPER_INDEX_VINTAGE){
        photoSize.width = PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT;
    }else if (currentPage == PAPER_INDEX_CRUMPLED){
        photoSize.width = PREVIEW_CRUMPLED_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_CRUMPLED_PHOTO_SIZE_HEIGHT;
    }else if (currentPage == PAPER_INDEX_FOLDED){
        photoSize.width = PREVIEW_FOLDED_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_FOLDED_PHOTO_SIZE_HEIGHT;
    }else{
        photoSize.width = PREVIEW_PHOTO_SIZE_WIDTH;
        photoSize.height = PREVIEW_PHOTO_SIZE_HEIGHT;
    }
    
    return photoSize;
}

- (CGFloat)getDevelopingPaperAlpha:(NSInteger)currentPage
{
    CGFloat retAlpha = 1.0f;
    
    switch (currentPage) {
        case PAPER_INDEX_WHITE:
            retAlpha = 0.0f;
            break;
        case PAPER_INDEX_POLARIOD:
        case PAPER_INDEX_ROLLED_UP:
        case PAPER_INDEX_SPRING:
        case PAPER_INDEX_VINTAGE:
            retAlpha = 1.0f;
            break;
        case PAPER_INDEX_FOLDED:
        case PAPER_INDEX_CRUMPLED:
            retAlpha = 0.3f;
            break;
        default:
            retAlpha = 1.0f;
            break;
    }
    
    return retAlpha;
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


@end

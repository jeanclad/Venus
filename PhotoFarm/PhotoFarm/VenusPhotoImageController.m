//
//  VenusPhotoImageController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 4. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusPhotoImageController.h"

@implementation VenusPhotoImageController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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

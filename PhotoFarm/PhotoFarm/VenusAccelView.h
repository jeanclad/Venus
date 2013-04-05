//
//  VenusAccelView.h
//  photo
//
//  Created by Dave Mark on 10/2/11.
//  Copyright (c) 2011 Dave Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface VenusAccelView : UIView

@property (strong, nonatomic) UIImage *image;
@property CGPoint currentPoint;
@property CGPoint previousPoint;
@property (assign, nonatomic) CMAcceleration acceleration;
@property CGFloat photoXVelocity;
@property CGFloat photoYVelocity;

- (void)initAccelImage:(UIImage *)photoImage;
- (void)updatePhotoPostion;

@end

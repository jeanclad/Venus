//
//  VenusAccelView.m
//  photo
//
//  Created by Dave Mark on 10/2/11.
//  Copyright (c) 2011 Dave Mark. All rights reserved.
//

#import "VenusAccelView.h"
#import "VenusMainViewController.h"

@implementation VenusAccelView
@synthesize image;
@synthesize currentPoint;
@synthesize previousPoint;
@synthesize acceleration;
@synthesize photoXVelocity;
@synthesize photoYVelocity;

- (id)initWithCoder:(NSCoder *)coder {
    
    /*
    if (self = [super initWithCoder:coder]) {
        self.image = [UIImage imageNamed:@"photo.png"];
        self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
                                        (image.size.width / 2.0f),
                                        (self.bounds.size.height / 2.0f) + (image.size.height / 2.0f));
        
        photoXVelocity = 0.0f;
        photoYVelocity = 0.0f;
    }
     */
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [image drawAtPoint:currentPoint];
    
}

#pragma mark -
- (void)initAccelImage:(UIImage *)photoImage {
    photoXVelocity = 0.0f;
    photoYVelocity = 0.0f;
    self.image = photoImage;
    NSLog(@"image size = %f, %f",self.image.size.width, self.image.size.height);
    
    CGRect rect = CGRectMake(0, 0, 480, 320);
    [self setBounds:rect];
    
    self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) + (PREVIEW_FRAME_SIZE_WIDTH / 2.0f), (self.bounds.size.height / 2.0f) + (PREVIEW_FRAME_SIZE_HEIGHT / 2.0f));
}

- (CGPoint)currentPoint {
    return currentPoint;
}

- (void)setCurrentPoint:(CGPoint)newPoint {
    previousPoint = currentPoint;
    currentPoint = newPoint;
    
    if (currentPoint.x < 0) {
        currentPoint.x = 0;
        photoXVelocity = 0;
    }
    if (currentPoint.y < 0){
        currentPoint.y = 0;
        photoYVelocity = 0;
    }
    if (currentPoint.x > self.bounds.size.width - image.size.width) {
        currentPoint.x = self.bounds.size.width - image.size.width;
        photoXVelocity = 0;
    }
    if (currentPoint.y > self.bounds.size.height - image.size.height) {
        currentPoint.y = self.bounds.size.height - image.size.height;
        photoYVelocity = 0;
    }
    
    NSLog(@"aa = %f", self.bounds.size.width - image.size.width);
    NSLog(@"bb = %f", self.bounds.size.height - image.size.height);
    
    CGRect currentImageRect = CGRectMake(currentPoint.x, currentPoint.y,
                                         currentPoint.x + image.size.width,
                                         currentPoint.y + image.size.height);
    CGRect previousImageRect = CGRectMake(previousPoint.x, previousPoint.y,
                                          previousPoint.x + image.size.width,
                                          currentPoint.y + image.size.width);
    [self setNeedsDisplayInRect:CGRectUnion(currentImageRect,
                                            previousImageRect)];
    
    NSLog(@"currentImageRect = %@, previousImageRect = %@", NSStringFromCGRect(currentImageRect), NSStringFromCGRect(previousImageRect));
}

- (void)updatePhotoPostion {
    static NSDate *lastUpdateTime;
    //NSLog(@"accel = %f, %f", acceleration.x, acceleration.y);
    
    if (lastUpdateTime != nil) {
        NSTimeInterval secondsSinceLastDraw =
        -([lastUpdateTime timeIntervalSinceNow]);
        
        photoYVelocity = photoYVelocity + -(acceleration.y *
                                          secondsSinceLastDraw);
        photoXVelocity = photoXVelocity + acceleration.x *
        secondsSinceLastDraw;
        
        CGFloat xAcceleration = secondsSinceLastDraw * photoXVelocity * 500;
        CGFloat yAcceleration = secondsSinceLastDraw * photoYVelocity * 500;
        
        self.currentPoint = CGPointMake(self.currentPoint.x +
                                        xAcceleration, self.currentPoint.y + yAcceleration);
    }
    // Update last time with current time
    lastUpdateTime = [[NSDate alloc] init];
}

@end

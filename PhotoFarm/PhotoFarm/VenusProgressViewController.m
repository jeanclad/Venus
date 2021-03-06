//
//  VenusProgressViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 27..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusProgressViewController.h"

#define kCustomProgressViewFillOffsetY  25
#define kCustomProgressViewFillOffsetLeftX 5
#define kCustomProgressViewFillOffsetRightX 10

#define BEAKER_MAX_PROGRESS 1.0f
//---   Float Pointing Compare Macro
#define float_epsilon 0.00001
#define float_equal(a,b) (fabs((a) - (b)) < float_epsilon)

@implementation VenusProgressViewController

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
    /* test by willProgress
    parentRect = rect;
    */
    
    progessHeight = rect.size.height;
    
    // Drawing code   
    UIImage *background = [UIImage imageNamed:@"beaker_off_ip4.png"];
    //UIImage *fill = [UIImage imageNamed:@"progress_fill_2.png"];
    
    // Draw the background in the current rect
    [background drawInRect:rect];
    
    // Compute the max width in pixels for the fill.  Max width being how
    // wide the fill should be at 100% progress.
    maxHeight = progessHeight - kCustomProgressViewFillOffsetY;
    
    // Compute the width for the current progress value, 0.0 - 1.0 corresponding
    // to 0% and 100% respectively.
    NSInteger curHeight = floor([self progress] * maxHeight);
    NSLog(@"curHeigth = %d", curHeight);
    
    // Create the rectangle for our fill image accounting for the position offsets,
    
    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
    CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetLeftX,
                                 rect.origin.y + progessHeight - curHeight,
                                 rect.size.width - kCustomProgressViewFillOffsetRightX,
                                 curHeight);
    
    // Draw the fill
    [fill drawInRect:fillRect];

    /* test by willProgress
    [self drawWillRect];
    */
}

/* test by willProgress
-(void)drawWillRect
{
    NSLog(@"parentRect = %f, %f", parentRect.size.width, parentRect.size.height);
}
*/

- (void)setFillImage:(int)index alpha:(float)alpha
{
    fill = [UIImage imageNamed:[NSString stringWithFormat:@"progress_fill_%d.png", index]];
    
    //---   fill 이미지의 알파값 적용
    CGSize newSize = CGSizeMake(fill.size.width, fill.size.height);
    UIGraphicsBeginImageContext(newSize);    
    [fill drawInRect:CGRectMake(0, 0, fill.size.width, fill.size.height) blendMode:kCGBlendModeNormal alpha:alpha];
    fill = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (float)calculateOverProgress:(float)progressPerOnce
{
    float willProgressLevel = self.progress + progressPerOnce;
    
    if (float_equal(willProgressLevel, BEAKER_MAX_PROGRESS)){
        willProgressLevel = BEAKER_MAX_PROGRESS;
    } else if (willProgressLevel > BEAKER_MAX_PROGRESS) {
        willProgressLevel = BEAKER_MAX_PROGRESS;
    } else if (willProgressLevel < 0){
        willProgressLevel = 0;
    }
    
    
    return willProgressLevel;
}

- (BOOL)isMaxProgress
{
    if (float_equal(self.progress, BEAKER_MAX_PROGRESS))
        return YES;
    else if (self.progress > BEAKER_MAX_PROGRESS)
        return YES;
    
    return NO;
}

- (BOOL)isMinProgress
{
    if (float_equal(self.progress, 0.0f))
        return YES;

    return NO;
}

- (float)getMaxHeight
{
    return maxHeight;
}

@end

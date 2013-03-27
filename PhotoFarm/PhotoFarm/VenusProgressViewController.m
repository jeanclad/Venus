//
//  VenusProgressViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 27..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusProgressViewController.h"

#define kCustomProgressViewFillOffsetY 15
#define kCustomProgressViewFillOffsetLeftX 5
#define kCustomProgressViewFillOffsetRightX 10

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
    progessHeight = rect.size.height;
    
    // Drawing code   
    UIImage *background = [UIImage imageNamed:@"beaker_off_ip4.png"];
    //UIImage *fill = [UIImage imageNamed:@"progress_fill_2.png"];
    
    // Draw the background in the current rect
    [background drawInRect:rect];
    
    // Compute the max width in pixels for the fill.  Max width being how
    // wide the fill should be at 100% progress.
    maxHeight = progessHeight - (2 * kCustomProgressViewFillOffsetY);
    
    // Compute the width for the current progress value, 0.0 - 1.0 corresponding
    // to 0% and 100% respectively.
    NSInteger curHeight = floor([self progress] * maxHeight);
    NSLog(@"curHeigth = %d", curHeight);
    
    // Create the rectangle for our fill image accounting for the position offsets,
    
    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
    CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetLeftX,
                                 rect.origin.y + progessHeight- curHeight,
                                 rect.size.width - kCustomProgressViewFillOffsetRightX,
                                 curHeight);
    
    // Draw the fill
    [fill drawInRect:fillRect];
}

- (void)setFillImage:(int)index
{
    fill = [UIImage imageNamed:[NSString stringWithFormat:@"progress_fill_%d.png", index]];
}

- (BOOL)calculateOverProgress:(float)progressPerOnce
{
    //--- floor는 내림함수
    NSInteger willHeight = floor([self progress] * maxHeight + [self progress] * maxHeight);
    NSLog(@"progress = %f", self.progress);
    if (willHeight > maxHeight) {
        return NO;
    }
    return YES;
}

@end

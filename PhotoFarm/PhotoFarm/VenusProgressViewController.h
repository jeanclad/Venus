//
//  VenusProgressViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 27..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenusProgressViewController : UIProgressView{
    CGRect parentRect;
    UIImage *fill;
    CGFloat  progessHeight;
    NSInteger maxHeight;
}

- (void)setFillImage:(int)index alpha:(float)alpha;
- (BOOL)calculateOverProgress:(float)progressPerOnce;

@end

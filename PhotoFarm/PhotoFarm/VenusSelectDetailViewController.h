//
//  VenusSelectDetailViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 21..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define HEIGHT_MARGIN   1

@interface VenusSelectDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (assign, nonatomic) NSUInteger itemValue;
@property (assign, nonatomic) NSInteger currentItem;

@end

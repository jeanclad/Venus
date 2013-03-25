//
//  VenusSelectDetailViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 21..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusSelectDetailViewController.h"
#import "VenusPersistList.h"

@interface VenusSelectDetailViewController ()

@end

@implementation VenusSelectDetailViewController

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
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[self.itemScrollView setBackgroundColor:[UIColor clearColor]];
	[self.itemScrollView setCanCancelContentTouches:NO];
	self.itemScrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	self.itemScrollView.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	self.itemScrollView.pagingEnabled = NO;
    
    self.itemScrollView.showsHorizontalScrollIndicator = NO;
    self.itemScrollView.showsVerticalScrollIndicator = NO;
    self.itemScrollView.directionalLockEnabled = YES;
    
    //Will edit jeanclad
    //---   view1 display
    CGFloat leftMargin = 30.0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat viewLine1PosY = naviBarHeight;
    UIView *viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewLine1PosY, 480.0, 80.0)];
    [viewLine1 setBackgroundColor:RGB(255, 239, 219)];
    [self.itemScrollView addSubview:viewLine1];
    
    UILabel *labelLine1 = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0.0, 450.0, 80.0)];
    [labelLine1 setBackgroundColor:RGB(255, 239, 219)];
    [labelLine1 setNumberOfLines:0];
    [labelLine1 setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.0]];
    if (self.itemValue == ITEM_VALUE_PAPER) {
            [labelLine1 setText:@"Photo Papers"];
    }
    else {
        [labelLine1 setText:@"Photo Developing Solutions"];
    }

    [labelLine1 setTextColor:[UIColor brownColor]];
    [viewLine1 addSubview:labelLine1];

    
    //---   view2 display
    leftMargin = 200.0;
    CGFloat viewLine2PosY = naviBarHeight + viewLine1.frame.size.height + HEIGHT_MARGIN;
    UIView *viewLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewLine2PosY, 480.0, 150.0)];
    [viewLine2 setBackgroundColor:RGB(250, 240, 230)];
    
    [self.itemScrollView addSubview:viewLine2];
    
    UILabel *labelLine2 = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0.0, 450.0, 80.0)];
    [labelLine2 setBackgroundColor:RGB(250, 240, 230)];
    [labelLine2 setNumberOfLines:0];
    [labelLine2 setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:15.0]];
    [labelLine2 setText:@"Blah Blah"];
    [labelLine2 setTextColor:[UIColor brownColor]];
    [viewLine2 addSubview:labelLine2];

    if (self.itemValue == ITEM_VALUE_PAPER) {
        NSString *paperImageName = [NSString stringWithFormat:@"paper_preview_%d.png", self.currentItem];
        UIImage *paperImage = [UIImage imageNamed:paperImageName];
        UIImageView *paperImageView = [[UIImageView alloc] initWithImage:paperImage];
        
        // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
        CGRect paperrect = paperImageView.frame;
        paperrect.size.width = 120;
        paperrect.size.height = 100;
        paperrect.origin.x = 70;
        paperrect.origin.y = 30;
        paperImageView.frame = paperrect;
        [viewLine2 addSubview:paperImageView];
        
        NSString *paperBoxImageName = [NSString stringWithFormat:@"select_box%d.png", self.currentItem];
        UIImage *paperBoxImage = [UIImage imageNamed:paperBoxImageName];
        UIImageView *paperBoxImageView = [[UIImageView alloc] initWithImage:paperBoxImage];
        
        // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
        CGRect paperBoxrect = paperBoxImageView.frame;
        paperBoxrect.size.width = 60;
        paperBoxrect.size.height = 60;
        paperBoxrect.origin.x = 30;
        paperBoxrect.origin.y = 10;
        paperBoxImageView.frame = paperBoxrect;
        [viewLine2 addSubview:paperBoxImageView];

    }
    else{
        NSString *chemicalImageName = [NSString stringWithFormat:@"select_solution0%d.png", self.currentItem+1];
        UIImage *chemicalImage = [UIImage imageNamed:chemicalImageName];
        UIImageView *chemicalImageView = [[UIImageView alloc] initWithImage:chemicalImage];
        
        // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
        CGRect chemicalrect = chemicalImageView.frame;
        chemicalrect.size.width = 65;
        chemicalrect.size.height = 120;
        chemicalrect.origin.x = 30;
        chemicalrect.origin.y = 10;
        chemicalImageView.frame = chemicalrect;
        [viewLine2 addSubview:chemicalImageView];
    }
    
    
    //---   view3 display
    leftMargin = 30.0;    
    CGFloat viewLine3PosY = viewLine2PosY + viewLine2.frame.size.height + HEIGHT_MARGIN;
    UIView *viewLine3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewLine3PosY, 480.0, 250.0)];
    [viewLine3 setBackgroundColor:RGB(250, 240, 230)];
    [self.itemScrollView addSubview:viewLine3];
    
    UILabel *labelLine3 = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0.0, 450.0, 80.0)];
    [labelLine3 setBackgroundColor:RGB(250, 240, 230)];
    [labelLine3 setNumberOfLines:0];
    [labelLine3 setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20.0]];
    [labelLine3 setText:@"Papers"];
    [labelLine3 setTextColor:[UIColor brownColor]];
    [viewLine3 addSubview:labelLine3];
    
    CGFloat totalLabelHeight = viewLine1.frame.size.height + viewLine2.frame.size.height + viewLine3.frame.size.height;
    
	[self.itemScrollView setContentSize:CGSizeMake(self.itemScrollView.bounds.size.width, totalLabelHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setItemScrollView:nil];
    [super viewDidUnload];
}
@end

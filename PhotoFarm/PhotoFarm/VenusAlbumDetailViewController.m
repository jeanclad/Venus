//
//  VenusAlbumDetailViewController.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusAlbumDetailViewController.h"

@interface VenusAlbumDetailViewController ()

@end

@implementation VenusAlbumDetailViewController

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
    
    //  제스쳐 설정 (페이지뷰 컨틀로러가 좌/우측 탭만 하여도 넘어가기 때문에 텝 이벤트를 오버라이딩하여
    //  네비게이션 바를 숨기고 보이는 용도로 사용함
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(onSingleTap:)];

    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark jeanclad
- (IBAction)buttonPressed:(UIButton *)sender
{
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"buttonName = %@", buttonName);
    
    if ([buttonName isEqualToString:@"Save"]){
        
    } else if ([buttonName isEqualToString:@"Delete"]){
        
    } else if ([buttonName isEqualToString:@"Info"]){
        
    } else if ([buttonName isEqualToString:@"Sns"]){
     
    }
}

- (void) onSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"gestureRecognizer: %d",gestureRecognizer.view.tag);
}
@end

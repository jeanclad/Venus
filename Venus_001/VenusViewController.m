//
//  VenusViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 19..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusViewController.h"

@interface VenusViewController ()

@end

@implementation VenusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    // 버튼종류를 알기위한 코드
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    NSLog(@"%@", buttonName);
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:@"사진촬영" otherButtonTitles:@"앨범에서 가져오기", nil];
    
    [actionsheet showInView:self.view];
}

// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagepickerController = [[UIImagePickerController alloc]init];
    [imagepickerController setDelegate:self];
    [imagepickerController setAllowsEditing:NO];
    
    if (buttonIndex == 0){
        [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentModalViewController:imagepickerController animated:YES];
    } else if (buttonIndex == 1){
        [self performSegueWithIdentifier:@"VenusFilmViewControllerId" sender:self];
    }
    
}

#pragma mark UIImagePickerController Delegate
@end

//
//  VenusMainViewController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusMainViewController.h"
#import "VenusFilmGroupViewController.h"

@interface VenusMainViewController ()

@end

@implementation VenusMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationItem.title = @"main";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    /*
     버튼종류를 알기위한 코드
     NSString *buttonName = [sender titleForState:UIControlStateNormal];
     NSLog(@"%@", buttonName);
     */
    
    NSString *string1 = NSLocalizedString(@"Cancel", @"취소");
    NSString *string2 = NSLocalizedString(@"ShootWithCamera", @"카메라");
    NSString *string3 = NSLocalizedString(@"SelectFromLibrary", @"사진앨범");
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:string1 destructiveButtonTitle:string2 otherButtonTitles:string3, nil];
    
    [actionsheet showInView:self.view];

    /*
    VenusFilmGroupViewController *VenusFilmGroupView = [[VenusFilmGroupViewController alloc] initWithNibName:@"VenusFilmGroupViewController" bundle:nil];
    [self.navigationController pushViewController:VenusFilmGroupView animated:YES];
     */
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagepickerController = [[UIImagePickerController alloc]init];
    [imagepickerController setDelegate:self];
    [imagepickerController setAllowsEditing:NO];
    
    NSString *string1 = NSLocalizedString(@"ErrCameraTitle", @"카메라 에러 타이틀");
    NSString *string2 = NSLocalizedString(@"ErrCameraMessage", @"카메라 에러 메세지");
    NSString *string3 = NSLocalizedString(@"Cancel", "취소");
    
    if (buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
            [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentModalViewController:imagepickerController animated:YES];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string1 message:string2 delegate:nil cancelButtonTitle:string3 otherButtonTitles:nil];
            [alert show];
        }
    } else if (buttonIndex == 1){
        VenusFilmGroupViewController *VenusFilmGroupView = [[VenusFilmGroupViewController alloc] initWithNibName:@"VenusFilmGroupViewController" bundle:nil];
        [self.navigationController pushViewController:VenusFilmGroupView animated:YES];
//        [self.navigationController presentModalViewController:VenusFilmGroupView animated:YES];
    }
    
}
@end

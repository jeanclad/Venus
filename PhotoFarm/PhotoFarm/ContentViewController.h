//
//  ContentViewController.h
//  TestPageController
//
//  Created by Wontai Ki on 12. 3. 15..
//  Copyright (c) 2012년 Young Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
{
    NSString* _mContentString;
    IBOutlet UILabel* _mContentLabel;
}
@property (strong, nonatomic) NSString* mContentString;
@property (strong, nonatomic) UILabel* mContentLabel;
@end
//
//  VenusSaveItemController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 4. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusSaveItemController.h"

@implementation VenusSaveItemController
- (NSArray *)makeSaveFileName
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYMMdd_hhmmss_a"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@",dateString);

    NSString *preloadPaperFileName = [NSString stringWithFormat:@"Venus_Paper_%@.png", dateString];
    NSString *preloadPaperlessFileName = [NSString stringWithFormat:@"Venus_Paperless_%@.png", dateString];
        
    NSArray *retFileName = [NSArray arrayWithObjects:preloadPaperFileName, preloadPaperlessFileName, nil];

    return retFileName;
}
@end

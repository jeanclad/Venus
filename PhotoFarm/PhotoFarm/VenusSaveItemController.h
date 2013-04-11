//
//  VenusSaveItemController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 4. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INDEX_PAPER_FILE        0
#define INDEX_PAPERLESS_FILE    1

@interface VenusSaveItemController : NSObject

- (NSArray *)makeSaveFileName;
@end

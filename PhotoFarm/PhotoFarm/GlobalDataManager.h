//
//  MMGlobalData.h
//  testSingleton
//
//  Created by SUNG CHEOL KIM on 10. 7. 29..
//  Copyright 2010 individual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenusPersistList.h"


@interface GlobalDataManager : NSObject 
{
    NSMutableArray  *selectedAssets;
}
+ (GlobalDataManager *) sharedGlobalDataManager;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@end

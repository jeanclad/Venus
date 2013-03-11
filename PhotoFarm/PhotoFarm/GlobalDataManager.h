//
//  MMGlobalData.h
//  testSingleton
//
//  Created by SUNG CHEOL KIM on 10. 7. 29..
//  Copyright 2010 individual. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalDataManager : NSObject 
{
    NSMutableArray  *assets;
}
+ (GlobalDataManager *) sharedGlobalDataManager;
@property (nonatomic, strong) NSMutableArray *assets;

@end

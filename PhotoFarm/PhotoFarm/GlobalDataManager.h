//
//  MMGlobalData.h
//  testSingleton
//
//  Created by SUNG CHEOL KIM on 10. 7. 29..
//  Copyright 2010 individual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface GlobalDataManager : NSObject 
{
    ALAsset *asset;
}
+ (GlobalDataManager *) sharedGlobalDataManager;
@property (nonatomic, retain) ALAsset *asset;

@end

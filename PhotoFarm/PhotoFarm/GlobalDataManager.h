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
    CGImageRef selectedImageRef;
}
+ (GlobalDataManager *) sharedGlobalDataManager;
@property (nonatomic, assign) CGImageRef selectedImageRef;

@end

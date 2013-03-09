//
//  VenusGlobalDataManager.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 9..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusGlobalDataManager.h"
#import "SynthesizeSingleton.h"


@implementation VenusGlobalDataManager

@synthesize asset;

SYNTHESIZE_SINGLETON_FOR_CLASS(VenusGlobalDataManager);
- (id) init
{
    if(self = [super init]) {
        self.asset = nil;
    }
    return self;
}

@end

//
//  GlobalDataManager.m
//  testSingleton
//
//  Created by SUNG CHEOL KIM on 10. 7. 29..
//  Copyright 2010 individual. All rights reserved.
//

#import "GlobalDataManager.h"
#import "SynthesizeSingleton.h"

@implementation GlobalDataManager
@synthesize asset;
SYNTHESIZE_SINGLETON_FOR_CLASS(GlobalDataManager);
- (id) init
{
	if(self = [super init]){
		self.asset = nil;
	}
	return self;
}
@end

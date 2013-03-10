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
@synthesize selectedImageRef;
SYNTHESIZE_SINGLETON_FOR_CLASS(GlobalDataManager);
- (id) init
{
	if(self = [super init]){
		self.selectedImageRef = nil;
	}
	return self;
}
@end

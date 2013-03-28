//
//  chemicalAnimation.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 28..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "chemicalAnimation.h"
#import "VenusPersistList.h"

@implementation chemicalAnimation

@synthesize firstAniDuration = _firstAniDuration;
@synthesize secondAniDuration = _secondAniDuration;
@synthesize waterDropAniDuration = _waterDropAniDuration;
@synthesize secondAniBeginTime = _secondAniBeginTime;
@synthesize totalAniDuration = _totalAniDuration;

@synthesize chemicalStartX = _chemicalStartX;
@synthesize chemicalStartY = _chemicalStartY;
@synthesize selectedChemicalIndex = _selectedChemicalIndex;
@synthesize chemicalAnimating = _chemicalAnimating;

- (id)init
{
    _chemicalOffSetX = 5;
    _chemicalOffSetY = 20;
    
    return self;
}
- (void)setChemicalAniDuration
{
    switch (self.selectedChemicalIndex) {
        case CHEMICAL_INDEX_DEVELOP_GREEN:
        case CHEMICAL_INDEX_DEVELOP_PINK:
        case CHEMICAL_INDEX_GLOOM:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 3.0f;
            self.secondAniBeginTime = 3.5f;
            break;
            
        case CHEMICAL_INDEX_CYAN:
        case CHEMICAL_INDEX_SUNNY:
        case CHEMICAL_INDEX_VALENTINE:
        case CHEMICAL_INDEX_YELLO:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 2.0f;
            self.secondAniBeginTime = 2.5f;
            break;
            
        case CHEMICAL_INDEX_1620:
        case CHEMICAL_INDEX_SPECIAL:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 1.0f;
            self.secondAniBeginTime = 1.5f;
            break;
            
        default:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 3.0f;
            self.secondAniBeginTime = 3.5f;            
            break;
    }
    
    self.totalAniDuration = self.firstAniDuration + self.waterDropAniDuration + self.secondAniDuration;
}
@end

//
//  chemicalAnimation.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 28..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "chemicalAnimation.h"
#import "VenusPersistList.h"

#define CHEMICAL_OFFSET_X   5
#define CHEMICAL_OFFSET_Y   20

#define CHEMICAL_MIN_LEVEL  0.2
#define CHEMICAL_LOW_LEVEL  0.4
#define CHEMICAL_MID_LEVEL  0.5
#define CHEMICAL_HIGH_LEVEL 0.7
#define CHEMICAL_MAX_LEVEL  1.0

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
    _chemicalOffSetX = CHEMICAL_OFFSET_X;
    _chemicalOffSetY = CHEMICAL_OFFSET_Y;
    
    chemicalLevelDevelopPink = CHEMICAL_MID_LEVEL;
    chemicalLevelDevelopGreen = CHEMICAL_MID_LEVEL;
    chemicalLevelGloom = CHEMICAL_MID_LEVEL;
    
    chemicalLevelCyan = CHEMICAL_LOW_LEVEL;
    chemicalLevelSunny = CHEMICAL_LOW_LEVEL;
    chemicalLevelValentine = CHEMICAL_LOW_LEVEL;
    chemicalLevelYello = CHEMICAL_LOW_LEVEL;
    
    chemicalLevel1620 = CHEMICAL_MIN_LEVEL;
    chemicalLevelSpecial = CHEMICAL_MIN_LEVEL;
    
    return self;
}
- (void)setChemicalAniDuration
{
    switch (self.selectedChemicalIndex) {
        case CHEMICAL_INDEX_DEVELOP_PINK:            
        case CHEMICAL_INDEX_DEVELOP_GREEN:
        case CHEMICAL_INDEX_GLOOM:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 2.0f;
            self.secondAniBeginTime = 2.5f;
            break;
            
        case CHEMICAL_INDEX_CYAN:
        case CHEMICAL_INDEX_SUNNY:
        case CHEMICAL_INDEX_VALENTINE:
        case CHEMICAL_INDEX_YELLO:
            self.firstAniDuration = 0.5f;
            self.secondAniDuration = 0.5f;
            self.waterDropAniDuration = 1.5f;
            self.secondAniBeginTime = 2.0f;
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

-(float)getChemicalPerOnceLevel:(int)selectedChemical
{
    float retChemicalLevel;
    
    switch (selectedChemical) {
        case CHEMICAL_INDEX_DEVELOP_PINK:
            retChemicalLevel = chemicalLevelDevelopPink;
            break;
        case CHEMICAL_INDEX_DEVELOP_GREEN:
            retChemicalLevel = chemicalLevelDevelopGreen;
            break;
        case CHEMICAL_INDEX_GLOOM:
            retChemicalLevel = chemicalLevelGloom;
            break;
        case CHEMICAL_INDEX_CYAN:
            retChemicalLevel = chemicalLevelCyan;
            break;
        case CHEMICAL_INDEX_SUNNY:
            retChemicalLevel = chemicalLevelSunny;
            break;
        case CHEMICAL_INDEX_VALENTINE:
            retChemicalLevel = chemicalLevelValentine;
            break;
        case CHEMICAL_INDEX_YELLO:
            retChemicalLevel = chemicalLevelYello;
            break;
        case CHEMICAL_INDEX_1620:
            retChemicalLevel = chemicalLevel1620;
            break;
        case CHEMICAL_INDEX_SPECIAL:
            retChemicalLevel = chemicalLevelSpecial;
            break;
        default:
            retChemicalLevel = chemicalLevelDevelopGreen;
            break;
    }

    return retChemicalLevel;
}
@end

//
//  chemicalAnimation.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 28..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chemicalAnimation : NSObject{
    float   chemicalLevelDevelopPink;
    float   chemicalLevelDevelopGreen;
    float   chemicalLevel1620;
    float   chemicalLevelYello;
    float   chemicalLevelValentine;
    float   chemicalLevelCyan;
    float   chemicalLevelSunny;
    float   chemicalLevelGloom;
    float   chemicalLevelSpecial;
    
    int _chemicalOffsetX;
    int _chemicalOffsetY;
    
    float _firstAniDuration;
    float _secondAniDuration;
    float _waterDropAniDuration;
    float _secondAniBeginTime;
    float _totalDuration;
    
    int _chemicalStartX;
    int _chemicalStartY;
    int _selectedChemicalIndex;
    BOOL _chemicalAnimating;
}
@property (nonatomic, readonly) NSInteger chemicalOffSetX;
@property (nonatomic, readonly) NSInteger chemicalOffSetY;

@property (nonatomic) float firstAniDuration;
@property (nonatomic) float secondAniDuration;
@property (nonatomic) float waterDropAniDuration;
@property (nonatomic) float secondAniBeginTime;
@property (nonatomic) float totalAniDuration;

@property (nonatomic) int chemicalStartX;
@property (nonatomic) int chemicalStartY;
@property (nonatomic) int selectedChemicalIndex;
@property (nonatomic) BOOL chemicalAnimating;

- (void)setChemicalAniDuration;
- (float)getChemicalPerOnceLevel:(int)selectedChemical;

@end

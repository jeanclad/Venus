//
//  VenusSaveItemController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 4. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusSaveItemController.h"
#import "VenusPersistList.h"

@implementation VenusSaveItemController
- (id) init
{
    _photoItemName = nil;
    _paperPhotoFileName = nil;
    _paperlessPhotoFileName = nil;
    _paperType = PAPER_TYPE_WHITE;
    _chemicalType = [[NSMutableArray alloc] init];
    
    return self;
}

- (NSDictionary *)makeSaveFileName
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYMMdd_hhmmss_a"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@",dateString);

    NSString *itemName = [NSString stringWithFormat:@"Venus_Paper_%@", dateString];
    NSString *preloadPaperFileName = [NSString stringWithFormat:@"Venus_Paper_%@.png", dateString];
    NSString *preloadPaperlessFileName = [NSString stringWithFormat:@"Venus_Paperless_%@.png", dateString];
    
    NSDictionary *retFileName = [NSDictionary dictionaryWithObjectsAndKeys:itemName, KEY_ITEM_NAME, preloadPaperFileName, KEY_PAPER_FILE_NAME, preloadPaperlessFileName, KEY_PAPERLESS_FILE_NAME, nil];

    return retFileName;
}

- (NSString *)getPaperName:(NSInteger)pageIndex
{
    NSString *retPaperName = nil;
    
    switch (pageIndex) {
        case PAPER_INDEX_WHITE:
            retPaperName = PAPER_TYPE_WHITE;
            break;
        case PAPER_INDEX_POLARIOD:
            retPaperName = PAPER_TYPE_POLAROID;
            break;
        case PAPER_INDEX_VINTAGE:
            retPaperName = PAPER_TYPE_VINTAGE;
            break;
        case PAPER_INDEX_ROLLED_UP:
            retPaperName = PAPER_TYPE_ROLLED_UP;
            break;
        case PAPER_INDEX_SPRING:
            retPaperName = PAPER_TYPE_SPRING;
            break;
        case PAPER_INDEX_FOLDED:
            retPaperName = PAPER_TYPE_FOLDED;
            break;
        case PAPER_INDEX_CRUMPLED:
            retPaperName = PAPER_TYPE_CRUMPLED;
            break;
        default:
            retPaperName = PAPER_TYPE_WHITE;
            break;
    }
    
    return retPaperName;
}

- (NSString *)getChemicalName:(NSInteger)pageIndex
{
    NSString *retChemicalName = nil;
    
    switch (pageIndex) {
        case CHEMICAL_INDEX_DEVELOP_PINK:
            retChemicalName = CHEMICAL_TYPE_DEVELOP_PINK;
            break;
        case CHEMICAL_INDEX_DEVELOP_GREEN:
            retChemicalName = CHEMICAL_TYPE_DEVELOP_GREEN;
            break;
        case CHEMICAL_INDEX_1620:
            retChemicalName = CHEMICAL_TYPE_1620;
            break;
        case CHEMICAL_INDEX_YELLO:
            retChemicalName = CHEMICAL_TYPE_YELLO;
            break;
        case CHEMICAL_INDEX_VALENTINE:
            retChemicalName = CHEMICAL_TYPE_VALENTINE;
            break;
        case CHEMICAL_INDEX_CYAN:
            retChemicalName = CHEMICAL_TYPE_CYAN;
            break;
        case CHEMICAL_INDEX_SUNNY:
            retChemicalName = CHEMICAL_TYPE_SUNNY;
            break;
        case CHEMICAL_INDEX_GLOOM:
            retChemicalName = CHEMICAL_TYPE_GLOOM;
            break;
        case CHEMICAL_INDEX_SPECIAL:
            retChemicalName = CHEMICAL_TYPE_SPECIAL;
            break;
            
    }
    
    return retChemicalName;
}

@end

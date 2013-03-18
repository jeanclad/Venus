//
//  VenusPersistList.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 13..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFilename         @"persist_photo_list.plist"
#define kDataKey          @"Data"

@interface VenusPersistList : NSObject

#define KEY_PHOTO_ITEM_NAME             @"photoItemName"
#define KEY_PAPER_PHOTO_FILE_NAME       @"paperPhotoFileName"
#define KEY_PAPERLESS_PHOTO_FILE_NAME   @"paperlessPhotoFileName"
#define KEY_PAPER_TYPE                  @"paperType";
#define KEY_CHEMICAL_TYPE               @"chemicalType"

#define INDEX_PHOTO_ITEM_NAME               0
#define INDEX_PAPER_PHOTO_FILE_NAME          1
#define INDEX_PAPERLESS_PHOTO_FILE_NAME     2
#define INDEX_PAPER_TYPE                    3
#define INDEX_CHEMICAL_TYPE                 4

typedef enum{
    PAPER_TYPE_NORMAL,
    PAPER_TYPE_POLAROID,
    PAPER_TYPE_VINTAGE,
    PAPER_TYPE_ROLLED_UP,
    PAPER_TYPE_SPRING,
    PAPER_TYPE_CRUMPLED,
    PAPERT_TYPE_FOLDED
}_paperType;

typedef enum{
    CHEMICAL_TYPE_DEVELOP_PINK,
    CHEMICAL_TYPE_DEVELOP_GREEN,
    CHEMICAL_TYPE_1620,
    CHEMICAL_TYPE_YELLO,
    CHEMICAL_TYPE_VALENTINE,
    CHEMICAL_TYPE_CYAN,
    CHEMICAL_TYPE_SUNNY,
    CHEMICAL_TYPE_GLOOM,
    CHEMICAL_TYPE_SPECIAL
}_chemicalType;

@property (nonatomic, retain) NSMutableDictionary   *persistList;
@property (nonatomic, retain) NSMutableArray        *photoItem;
@property (nonatomic, retain) NSString              *photoItemName;
@property (nonatomic, retain) NSString              *paperPhotoFileName;
@property (nonatomic, retain) NSString              *paperlessPhotoFileName;
@property (nonatomic, retain) NSNumber              *paperType;
@property (nonatomic, retain) NSNumber              *chemicalType;

- (void)fillPlistData;
- (void)allocPlistData;
@end

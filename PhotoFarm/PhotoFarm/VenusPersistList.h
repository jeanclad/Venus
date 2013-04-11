//
//  VenusPersistList.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 13..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CHEMICAL_INDEX_DEVELOP_PINK,
    CHEMICAL_INDEX_DEVELOP_GREEN,
    CHEMICAL_INDEX_1620,
    CHEMICAL_INDEX_YELLO,
    CHEMICAL_INDEX_VALENTINE,
    CHEMICAL_INDEX_CYAN,
    CHEMICAL_INDEX_SUNNY,
    CHEMICAL_INDEX_GLOOM,
    CHEMICAL_INDEX_SPECIAL,
}chemialIndex;

typedef enum{
    PAPER_INDEX_WHITE,
    PAPER_INDEX_POLARIOD,
    PAPER_INDEX_VINTAGE,
    PAPER_INDEX_ROLLED_UP,
    PAPER_INDEX_SPRING,
    PAPER_INDEX_CRUMPLED,
    PAPER_INDEX_FOLDED,
}paperIndex;

#define kFilename         @"persist_photo_list.plist"
#define kDataKey          @"Data"

#define KEY_PHOTO_ITEM_NAME             @"photoItemName"
#define KEY_PAPER_PHOTO_FILE_NAME       @"paperPhotoFileName"
#define KEY_PAPERLESS_PHOTO_FILE_NAME   @"paperlessPhotoFileName"
#define KEY_PAPER_TYPE                  @"paperType";
#define KEY_CHEMICAL_TYPE               @"chemicalType"

#define CHEMICAL_TYPE_DEVELOP_PINK      @"Pink Develop"
#define CHEMICAL_TYPE_DEVELOP_GREEN     @"Green Develop"
#define CHEMICAL_TYPE_1620              @"1620"
#define CHEMICAL_TYPE_YELLO             @"Yello"
#define CHEMICAL_TYPE_VALENTINE         @"Valentine"
#define CHEMICAL_TYPE_CYAN              @"Cyan"
#define CHEMICAL_TYPE_SUNNY             @"Sunny"
#define CHEMICAL_TYPE_GLOOM             @"Gloom"
#define CHEMICAL_TYPE_SPECIAL           @"Special"
 
#define PAPER_TYPE_WHITE                @"White Paper"
#define PAPER_TYPE_POLAROID             @"Polaroid Paper"
#define PAPER_TYPE_VINTAGE              @"Vintage Paper"
#define PAPER_TYPE_ROLLED_UP            @"Rolled Up Paper"
#define PAPER_TYPE_SPRING               @"Spring Paper"
#define PAPER_TYPE_CRUMPLED             @"Crumpled Paper"
#define PAPER_TYPE_FOLDED               @"Folded Paper"

#define INDEX_PHOTO_ITEM_NAME               0
#define INDEX_PAPER_PHOTO_FILE_NAME         1
#define INDEX_PAPERLESS_PHOTO_FILE_NAME     2
#define INDEX_PAPER_TYPE                    3
#define INDEX_CHEMICAL_TYPE                 4

#define ITEM_VALUE_PAPER                    1
#define ITEM_VALUE_CHEMICAL                 2

@interface VenusPersistList : NSObject

@property (nonatomic, retain) NSMutableDictionary   *persistList;
@property (nonatomic, retain) NSMutableArray        *photoItem;
@property (nonatomic, retain) NSString              *photoItemName;
@property (nonatomic, retain) NSString              *paperPhotoFileName;
@property (nonatomic, retain) NSString              *paperlessPhotoFileName;
@property (nonatomic, retain) NSString              *paperType;
@property (nonatomic, retain) NSMutableArray        *chemicalType;

- (void)fillPlistData;
- (void)allocPlistData;
@end

//
//  VenusPersistList.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 13..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MYDEVICE_IPHONE5                1
#define MYDEVICE_ETC                    2
#define IP5_SIZE_WIDTH                  568
#define IP4_SIZE_WIDTH                  480
#define IP4_IP5_SIZE_HEIGHT             320

#define SELECT_RIGHT_MOVE_X_IP5         284
#define SELECT_RIGHT_MOVE_X_IP4         240
#define SELECT_RIGHT_MOVE_Y             50

#define SELECT_BUTTON_MOVE_X_IP5        80
#define SELECT_BUTTON_MOVE_X_IP4        60
#define SELECT_BUTTON_MOVE_Y            60

#define PINCETTE_SIZE_WIDTH             95
#define PINCETTE_SIZE_HEIGHT            68

#define PREVIEW_ORIGIN_X                    0
#define PREVIEW_ORIGIN_Y                    0
#define PREVIEW_NO_MOVE_FRAME_SIZE_WIDTH    140
#define PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT   140

#define PAPER_PHOTO_SIZE                    200
#define PAPERLESS_PHOTO_SIZE                320

#define PREVIEW_FRAME_SIZE_WIDTH            200
#define PREVIEW_FRAME_SIZE_HEIGHT           200
#define PREVIEW_PHOTO_SIZE_WIDTH            200
#define PREVIEW_PHOTO_SIZE_HEIGHT           200

#define PREVIEW_NOT_PAPER_PHOTO_ORIGIN_X        0
#define PREVIEW_NOT_PAPER_PHOTO_ORIGIN_Y        0
#define PREVIEW_NOT_PAPER_PHOTO_SIZE_WIDTH      200
#define PREVIEW_NOT_PAPER_PHOTO_SIZE_HEIGHT     200

#define PREVIEW_POLAROID_PHOTO_ORIGIN_X         25
#define PREVIEW_POLAROID_PHOTO_ORIGIN_Y         5
#define PREVIEW_POLAROID_PHOTO_SIZE_WIDTH       150
#define PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT      150

#define PREVIEW_ROLLED_UP_PHOTO_ORIGIN_X        20
#define PREVIEW_ROLLED_UP_PHOTO_ORIGIN_Y        15
#define PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH      160
#define PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT     160

#define PREVIEW_SPRING_PHOTO_ORIGIN_X           15
#define PREVIEW_SPRING_PHOTO_ORIGIN_Y           15
#define PREVIEW_SPRING_PHOTO_SIZE_WIDTH         170
#define PREVIEW_SPRING_PHOTO_SIZE_HEIGHT        170

#define PREVIEW_VINTAGE_PHOTO_ORIGIN_X          15
#define PREVIEW_VINTAGE_PHOTO_ORIGIN_Y          15
#define PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH        170
#define PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT       170

#define PREVIEW_CRUMPLED_PHOTO_ORIGIN_X         0
#define PREVIEW_CRUMPLED_PHOTO_ORIGIN_Y         0
#define PREVIEW_CRUMPLED_PHOTO_SIZE_WIDTH      200
#define PREVIEW_CRUMPLED_PHOTO_SIZE_HEIGHT     200

#define PREVIEW_FOLDED_PHOTO_ORIGIN_X           0
#define PREVIEW_FOLDED_PHOTO_ORIGIN_Y           0
#define PREVIEW_FOLDED_PHOTO_SIZE_WIDTH         200
#define PREVIEW_FOLDED_PHOTO_SIZE_HEIGHT        200

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

//
//  VenusSaveItemController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 4. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenusPersistList.h"

#define KEY_ITEM_NAME               @"keyItemName"
#define KEY_PAPER_FILE_NAME         @"keyPaperFileName"
#define KEY_PAPERLESS_FILE_NAME     @"keyPaperlessFileName"

@interface VenusSaveItemController : NSObject

@property (nonatomic, retain) NSString              *photoItemName;
@property (nonatomic, retain) NSString              *paperPhotoFileName;
@property (nonatomic, retain) NSString              *paperlessPhotoFileName;
@property (nonatomic, retain) NSString              *paperType;
@property (nonatomic, retain) NSMutableArray        *chemicalType;           

//---   앨범뷰에 사용될 사진+용지 이미지 (200*200)
@property (nonatomic, retain) UIImage               *albumPaperPhotoImage;
//---   앨범뷰에 사용될 사진 이미지 (320*320)
@property (nonatomic, retain) UIImage               *albumPaperlessPhotoImage;

- (NSDictionary *)makeSaveFileName;
- (NSString *)getPaperName:(NSInteger)pageIndex;
- (NSString *)getChemicalName:(NSInteger)pageIndex;
- (void)writeToDataFile:(VenusPersistList *)persist;
- (BOOL)loadPlistFile;
- (void)savePropFile;
- (void)saveImageFile;
- (void)deleteImageFile:(NSString *)fileOne fileTwo:(NSString *)fileTwo;
- (NSData *)loadToCacheImageFile:(NSString *)fileName;
@end

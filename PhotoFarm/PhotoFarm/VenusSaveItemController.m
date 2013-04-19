//
//  VenusSaveItemController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 4. 11..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusSaveItemController.h"
#import "GlobalDataManager.h"

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
    //[dateFormatter setDateFormat:@"YYMMdd_hhmmss_a"];
    [dateFormatter setDateFormat:@"YYMMdd_HHmmss"];    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@",dateString);

    NSString *itemName = [NSString stringWithFormat:@"Venus_Paper_%@", dateString];
    NSString *preloadPaperFileName = [NSString stringWithFormat:@"Venus_Paper_%@.jpg", dateString];
    NSString *preloadPaperlessFileName = [NSString stringWithFormat:@"Venus_Paperless_%@.jpg", dateString];
    
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

- (void)writeToDataFile:(VenusPersistList *)persist
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:persist forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    //NSLog(@"persistList_load = %@", [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList persistList]);
}

- (void)writeToCacheImageFile:(UIImage *)photoImage fileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *filePath = [cachesDirectory stringByAppendingPathComponent:fileName];
    UIImage *image = photoImage;
    //NSData *saveImageData = UIImagePNGRepresentation(image);
    NSData *saveImageData = UIImageJPEGRepresentation(image, 1.0f);
    [saveImageData writeToFile:filePath atomically:NO];
}

- (NSData *)loadToCacheImageFile:(NSString *)fileName
{
    //---   저장된 파일을 로딩한다.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:fileName];
    NSData *loadImageData = [NSData dataWithContentsOfFile:path];
    
    return loadImageData;
}

- (void)saveImageFile
{
    //---   아이템 임시 저장 클래스에 아이템 네임과 파일명을 저장한다.
    NSDictionary *preloadName = [self makeSaveFileName];
    _photoItemName = [preloadName objectForKey:KEY_ITEM_NAME];
    _paperPhotoFileName = [preloadName objectForKey:KEY_PAPER_FILE_NAME];
    _paperlessPhotoFileName = [preloadName objectForKey:KEY_PAPERLESS_FILE_NAME];
    
    //---   Save PaperPhotoFile
    [self writeToCacheImageFile:_albumPaperPhotoImage fileName:_paperPhotoFileName];
    
    //---   Save PaperlessPhotoFile
    [self writeToCacheImageFile:_albumPaperlessPhotoImage fileName:_paperlessPhotoFileName];
}

- (void)savePropFile
{
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPhotoItemName:_photoItemName];
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperPhotoFileName:_paperPhotoFileName];
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperlessPhotoFileName:_paperlessPhotoFileName];
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setPaperType:_paperType];
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList setChemicalType:_chemicalType];
    
    [[GlobalDataManager sharedGlobalDataManager].photoInfoFileList fillPlistData];
    
    [self writeToDataFile:[GlobalDataManager sharedGlobalDataManager].photoInfoFileList];
    
    //---    Plist파일을 갱신한 후에는 반듯이 다시 읽어와야 한다.
    [self loadPlistFile];
}

- (void)deleteImageFile:(NSString *)fileOne fileTwo:(NSString *)fileTwo
{
    // documents 폴더의 경로 얻기
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    //---   Paper 파일 삭제
    NSString *filePath = [docPath stringByAppendingPathComponent:fileOne];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    
    //---   Paperless 파일 삭제
    docPath = nil;
    docPath = [paths objectAtIndex:0];
    filePath = [docPath stringByAppendingPathComponent:fileTwo];
    [fileManager removeItemAtPath:filePath error:nil];
    
}

#pragma mark -
#pragma mark Persist Control
- (BOOL)loadPlistFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //---   아카이빙 으로 plist을 읽어온다.
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        [GlobalDataManager sharedGlobalDataManager].photoInfoFileList = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        //NSLog(@"loadPlist = %@ count = %d", loadPersistList.persistList, loadPersistList.persistList.count);
        
        
        //---   plist를 맨 마지막 저장된 것이 맨 처음 인덱스로 오도록 역순으로 sorting 한다.
        NSArray *allKeys = [[NSArray alloc] initWithArray:[[GlobalDataManager sharedGlobalDataManager].photoInfoFileList.persistList allKeys]];
        //NSLog(@"Allkeys = %@", allKeys);
        
        NSArray *tmpArray = [[NSArray alloc] initWithArray:allKeys];
        
        tmpArray = [allKeys sortedArrayUsingSelector:@selector(compare:)];
        //NSLog(@"sort = %@", tmpArray);
        
        NSEnumerator *enumReverse = [tmpArray reverseObjectEnumerator];
        NSString *tmpString;
        
        [GlobalDataManager sharedGlobalDataManager].reversePlistKeys = [[NSMutableArray alloc] init];
        
        while(tmpString = [enumReverse nextObject]){
            //NSLog(@"tmpString = %@", tmpString);
            [[GlobalDataManager sharedGlobalDataManager].reversePlistKeys addObject:tmpString];
        }
        
        //NSLog(@"dictAllKeys = %@", [GlobalDataManager sharedGlobalDataManager].reversePlistKeys);
        
        //--- Debug Code
        //for (int i = 0; i < allKeys.count; i++){
        // NSLog(@"first key paper type = %@", [[venusloadPlist.persistList objectForKey:[tmpDictArray objectAtIndex:i]] objectAtIndex:INDEX_PAPER_TYPE]);
        //}
        //
        
        return YES;
    }
    return NO;
}
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

@end

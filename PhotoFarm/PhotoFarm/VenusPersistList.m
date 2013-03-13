//
//  VenusPersistList.m
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 13..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusPersistList.h"

#define    kPersistList    @"PersistList"

@implementation VenusPersistList

#pragma mark    jeanclad
- (void)fillPlistData
{
    
    if (self.photoItem == nil){
        NSLog(@"photoItem is nil, so alloc with memory");
        self.photoItem = [[NSMutableArray alloc] init];
    }
    
    [self.photoItem addObject:self.photoItemName];
    [self.photoItem addObject:self.paperPhotoFileName];
    [self.photoItem addObject:self.paperlessPhotoFileName];
    [self.photoItem addObject:self.paperType];
    [self.photoItem addObject:self.chemicalType];
    
    
    if (self.persistList == nil){
        NSLog(@"persistList is nil, so alloc with memory");
        self.persistList = [[NSMutableDictionary alloc] init];
    }
    
    [self.persistList setObject:self.photoItem forKey:self.photoItemName];
   
    self.photoItem = nil;
    self.photoItemName = nil;
    self.paperPhotoFileName = nil;
    self.paperlessPhotoFileName = nil;
    self.paperType = nil;
    self.chemicalType = nil;
    
    //NSLog(@"persistList = %@", self.persistList);
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.persistList forKey:kPersistList];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.persistList = [decoder decodeObjectForKey:kPersistList];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    VenusPersistList *copy = [[[self class] allocWithZone: zone] init];
    copy.persistList = [self.persistList copyWithZone:zone];
    return copy;
}

@end

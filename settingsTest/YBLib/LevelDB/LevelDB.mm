//
//  LevelDB.m
//  BaseApp
//
//  Created by 胡峰 on 15/8/10.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "LevelDB.h"
#include "db.h"
#include "status.h"
#include "options.h"
#include "slice.h"

#define SliceFromString(_string_) (Slice((char *)[_string_ UTF8String], [_string_ lengthOfBytesUsingEncoding:NSUTF8StringEncoding]))
#define StringFromSlice(_slice_) ([[NSString alloc] initWithBytes:_slice_.data() length:_slice_.size() encoding:NSUTF8StringEncoding])

static leveldb::DB * db;
static leveldb::Options options;

using namespace leveldb;
static Slice SliceFromObject(id object) {
    NSMutableData *d = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:d];
    [archiver encodeObject:object forKey:@"object"];
    [archiver finishEncoding];
    return Slice((const char *)[d bytes], (size_t)[d length]);
}

static id ObjectFromSlice(Slice v) {
    NSData *data = [NSData dataWithBytes:v.data() length:v.size()];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:@"object"];
    [unarchiver finishDecoding];
    return object;
}

@implementation LevelDB

+ (LevelDB *) db{
    if(db == NULL){
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directoryPaths objectAtIndex:0];
        NSString * file = [documentDirectory stringByAppendingPathComponent:@"storage.ldb"];
        options.create_if_missing = true;
        leveldb::Status status = leveldb::DB::Open(options, [file UTF8String], & db);
        if(!status.ok()){
            [YBException newYBException:@"write_to_DB_File_fail" reason:@"the_wrong_db" userInfo:@{}];
        }
        NSLog(@"Problem creating LevelDB database: %s", status.ToString().c_str());
    }
    
    return [[LevelDB alloc] init];
}

- (void) set:(NSString *) key value:(id) value {
    [self del:key];
    leveldb::Status status = db->Put(leveldb::WriteOptions(), SliceFromString(key), SliceFromObject(value));
    if(!status.ok()){
        [YBException newYBException:@"set_to_DB_fail" reason:@"db_error_OR_diskFull" userInfo:@{}];
    }
    NSLog(@"SET status: %s", status.ToString().c_str());
}

- (id) get:(NSString *) key {
    std::string strValue;
    leveldb::Status status = db->Get(leveldb::ReadOptions(), SliceFromString(key), & strValue);
    
    if(!(status.ok())) {
        return nil;
    }
    return ObjectFromSlice(strValue);
}
- (void) del:(NSString *) key {
    std::string strValue;
    leveldb::Status status = db->Delete(leveldb::WriteOptions(), SliceFromString(key));
    if(!status.ok()){
        [YBException newYBException:@"del_to_DB_fail" reason:@"wrong_key" userInfo:@{}];
    }
    NSLog(@"SET status: %s", status.ToString().c_str());
}

@end

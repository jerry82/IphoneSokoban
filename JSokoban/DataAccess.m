//
//  DataAccess.m
//  JSokoban
//
//  Created by Jerry on 10/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "DataAccess.h"
#import "FMDatabase.h"

@implementation DataAccess {
    FMDatabase* db;
}

NSString* DatabasePath;

//singleton
//---singleton pattern--------------------------------------------
+(id) sharedInstance {
    
    static dispatch_once_t pred;
    
    static DataAccess *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[DataAccess alloc] initWithPath];
    });
    
    return sharedInstance;
}

- (id) initWithPath {
    if (self = [super init]) {
        NSLog(@"%d", DatabasePath.length);
        
        if ([DatabasePath length] == 0)
            NSLog(@"DatabasePath is not set");
        else
            db = [FMDatabase databaseWithPath:DatabasePath];
    }
    return self;
}


- (NSString*) getLevel:(int)level {
    NSString* tmp = [[NSString alloc] init];
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT level.content from level where level.id = ?", [NSNumber numberWithInt:level]];
                       
    while ([rs next]) {
        tmp = [rs stringForColumn:@"content"];
        NSLog(@"content: %@", tmp);
        break;
    }
    
    [db close];
    
    return tmp;
}

@end

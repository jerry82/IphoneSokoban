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
        //NSLog(@"%lu", DatabasePath.length);
        
        if ([DatabasePath length] == 0)
            NSLog(@"DatabasePath is not set");
        else {
            db = [FMDatabase databaseWithPath:DatabasePath];
            //TODO: debugging
            db.logsErrors = YES;
        }
    }
    return self;
}


- (LevelDetailItem*) getNextLevelDetailItem:(int)pack currentLevel:(int)curLevel {
    
    LevelDetailItem* levelItem = [[LevelDetailItem alloc] init];
    //int nextLevel = level + 1;
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    //select the next level, level is not in sequence (+1)
    FMResultSet *rs = [db executeQuery:@"SELECT content, packId, levelnum from level_detail where packId = ? and levelnum > ? order by levelnum limit 1",
                       [NSNumber numberWithInt:pack],
                       [NSNumber numberWithInt:curLevel]];
                       
    while ([rs next]) {
        levelItem.Content = [rs stringForColumn:@"content"];
        levelItem.LevelNum = [rs intForColumn:@"levelnum"];
        levelItem.PackId = [rs intForColumn:@"packId"];
        
        //NSLog(@"content: %@", tmp);
        break;
    }
    
    [rs close];
    
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
    
    return levelItem;
}

- (NSMutableArray *) getAllEpisodes {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT id, description, current_level, custom.total AS total FROM pack AS p JOIN (SELECT packId, count(packId) AS total FROM level_detail GROUP BY packId) AS custom ON p.id = custom.packId"];
    
    while ([rs next]) {
        EpisodeItem* item = [[EpisodeItem alloc] init];
        item.PackId = [rs intForColumn:@"id"];
        item.description = [rs stringForColumn:@"description"];
        item.LevelCompleted = [rs intForColumn:@"current_level"] - 1;
        if (item.LevelCompleted < 0) {
            item.LevelCompleted = 0;
        }
        item.NumOfLevels = [rs intForColumn:@"total"];
        
        [arr addObject:item];
        
    }
    
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [rs close];
    [db close];
    
    return arr;
}

- (void) updateGameWin: (LevelDetailItem*) curLevelItem {
    if (![db open]) {
        NSLog(@"db failed to open");
        return;
    }
    
    int nextLevel = curLevelItem.LevelNum + 1;

    [db executeUpdate:@"UPDATE pack set current_level = ? where id = ?",
                        [NSNumber numberWithInt:nextLevel],
                        [NSNumber numberWithInt:curLevelItem.PackId]];

    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
}

@end

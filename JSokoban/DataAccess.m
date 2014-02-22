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
    FMDatabase* _db;
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
            _db = [FMDatabase databaseWithPath:DatabasePath];
            //TODO: debugging
            _db.logsErrors = YES;
        }
    }
    return self;
}


- (LevelDetailItem*) getNextLevelDetailItem:(int)pack currentLevel:(int)curLevel add: (int)num {
    
    LevelDetailItem* levelItem = [[LevelDetailItem alloc] init];
    int nextLevel = curLevel + num;
    
    if (![_db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    /*
    FMResultSet *rs = [db executeQuery:@"SELECT content, packId, levelnum from level_detail where packId = ? and levelnum > ? order by levelnum limit 1",
                       [NSNumber numberWithInt:pack],
                       [NSNumber numberWithInt:curLevel]];
    */
    
    FMResultSet *rs = [_db executeQuery:@"SELECT content, packId, levelnum from level_detail where packId = ? and levelnum = ?",
                       [NSNumber numberWithInt:pack],
                       [NSNumber numberWithInt:nextLevel]];

    while ([rs next]) {
        levelItem.Content = [rs stringForColumn:@"content"];
        levelItem.LevelNum = [rs intForColumn:@"levelnum"];
        levelItem.PackId = [rs intForColumn:@"packId"];
        
        //NSLog(@"content: %@", tmp);
        break;
    }
    
    [rs close];
    
    if ([_db hadError]) {
        NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    [_db close];
    
    return levelItem;
}

- (NSMutableArray *) getAllEpisodes {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    if (![_db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    FMResultSet *rs = [_db executeQuery:@"SELECT id, description, current_level, lock, custom.total AS total FROM pack AS p JOIN (SELECT packId, count(packId) AS total FROM level_detail GROUP BY packId) AS custom ON p.id = custom.packId"];
    
    while ([rs next]) {
        EpisodeItem* item = [[EpisodeItem alloc] init];
        item.PackId = [rs intForColumn:@"id"];
        item.description = [rs stringForColumn:@"description"];
        item.LevelCompleted = [rs intForColumn:@"current_level"] - 1;
        item.Lock = [rs intForColumn:@"lock"];
        
        if (item.LevelCompleted < 0) {
            item.LevelCompleted = 0;
        }
        item.NumOfLevels = [rs intForColumn:@"total"];
        
        [arr addObject:item];
        
    }
    
    if ([_db hadError]) {
        NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    [rs close];
    [_db close];
    
    return arr;
}

- (void) updateGameWin: (LevelDetailItem*) curLevelItem {
    if (![_db open]) {
        NSLog(@"db failed to open");
        return;
    }
    
    int nextLevel = curLevelItem.LevelNum + 1;

    [_db executeUpdate:@"UPDATE pack set current_level = ? where id = ? and current_level < ?",
                        [NSNumber numberWithInt:nextLevel],
                        [NSNumber numberWithInt:curLevelItem.PackId],
                        [NSNumber numberWithInt:nextLevel]];
 
    if ([_db hadError]) {
        NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    [_db close];
}

- (BOOL) isLastLevelOfEpisode: (LevelDetailItem*) curLevelItem {
    
    BOOL lastLevel = NO;

    if (![_db open]) {
        NSLog(@"db failed to open");
        return lastLevel;
    }
    
    FMResultSet *rs = [_db executeQuery: @"SELECT count(id) as total FROM level_detail where packId = ?",
                       [NSNumber numberWithInt: curLevelItem.PackId]];
    
    int cnt = 0;
    
    while ([rs next]) {
        cnt = [rs intForColumn:@"total"];
        break;
    }
    
    
    if ([_db hadError]) {
        NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    [_db close];
    
    
    return lastLevel = (cnt == curLevelItem.LevelNum);
}

- (int) isLastLevel: (LevelDetailItem*) curLevelItem {
    int result = 0;
    
    if ([self isLastLevelOfEpisode:curLevelItem]) {
        
        
        
        int nextPackId = curLevelItem.PackId + 1;
        
        if (![_db open]) {
            NSLog(@"db failed to open");
            return result;
        }

        result = 2;
        
        FMResultSet* rs = [_db executeQuery:@"SELECT id from pack where id = ?", [NSNumber numberWithInt:nextPackId]];
        
        while ([rs next]) {
            result = 1;
            break;
        }
        
        if ([_db hadError]) {
            NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
        }
        
        [_db close];
    }
    
    return result;
}

- (void) unlockEpisode: (int) packId {
    if (![_db open]) {
        NSLog(@"db failed to open");
        return;
    }
    
    [_db executeUpdate:@"UPDATE pack set lock = 0 where id = ?",
     [NSNumber numberWithInt:packId]];

    
    if ([_db hadError]) {
        NSLog(@"DB Error %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    [_db close];
}

@end

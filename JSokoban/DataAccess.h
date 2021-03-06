//
//  DataAccess.h
//  JSokoban
//
//  Created by Jerry on 10/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelDetailItem.h"
#import "EpisodeItem.h"

@interface DataAccess : NSObject {
    
}

extern NSString* DatabasePath;

+ (id) sharedInstance;

- (LevelDetailItem*) getNextLevelDetailItem: (int) pack currentLevel: (int) level add: (int) num;

- (NSMutableArray*) getAllEpisodes;

- (void) updateGameWin: (LevelDetailItem*) curLevelItem;

- (int) isLastLevel: (LevelDetailItem*) curLevelItem;

- (void) unlockEpisode: (int) packId;

@end

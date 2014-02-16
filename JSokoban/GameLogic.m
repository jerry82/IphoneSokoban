//
//  GameLogic.m
//  JSokoban
//
//  Created by Jerry on 6/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameLogic.h"
#import "PathFinder.h"
#import "DataAccess.h"

@implementation GameLogic {
    NSMutableArray* maze;
    PathFinder* pathFinder;
}

//singleton
+ (id) sharedGameLogic {
    static GameLogic* sharedThisGameLogic = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedThisGameLogic = [[self alloc] init];
    });
    
    return sharedThisGameLogic;
}

/*
 * const declaration
 */
const char BLOCK_CHAR = '#';
const char SPOT_CHAR = '.';

const char BOT_CHAR = '@';
const char BOX_CHAR = '$';
const char PATH_CHAR = ' ';
//const char BOX_ON_SPOT = 'x';
const char BOX_ON_SPOT = '*';

NSString* const BLOCK_IMG = @"block40";
NSString* const SPOT_IMG = @"spot40";
NSString* const BOT_IMG = @"bot40";
NSString* const BOX_IMG = @"box40";
NSString* const CANMOVE_IMG = @"canMove40";
NSString* const CANNOTMOVE_IMG = @"cannotMove40";
NSString* const SCREEN_IMG = @"screen";

NSString* const PATH_OUTBOUND = @"OUTBOUND";
//menu
NSString* const REFRESH_IMG = @"refresh50";

NSString* const UP_IMG = @"up50";
NSString* const UP_NAME = @"up_btn";
NSString* const DOWN_IMG = @"down50";
NSString* const DOWN_NAME = @"down_btn";

NSString* const RESTARTBTN_IMG = @"restart_btn50";
NSString* const RESTARTBTN_NAME = @"restart_btn";

NSString* const NEXTBTN_IMG = @"next_btn50";
NSString* const NEXTBTN_NAME = @"next_btn";

NSString* const BACKBTN_IMG = @"back_btn50";
NSString* const BACKBTN_NAME = @"back_btn";

NSString* const MENUBTN_IMG = @"menu_btn50";
NSString* const MENUBTN_NAME = @"menu_btn";

NSString* const SOUNDONBTN_IMG = @"radioon_btn50";
NSString* const SOUNDONBTN_NAME = @"radioon_btn";

NSString* const HELPBTN_IMG = @"help50";
NSString* const HELPBTN_NAME = @"help_btn";

NSString* const MENUBAR_IMG = @"menu";
NSString* const MENUBAR_NAME = @"menubar";

NSString* const MENU_NAME = @"menu";
NSString* const MENUBG_NAME = @"menu_bg";

NSString* const WINDIALOG_NAME = @"windialog";
NSString* const WINDIALOG_IMG = @"popup";

NSString* const PAUSE_IMG = @"pause50";
NSString* const PAUSE_NAME = @"pause";

NSString* const BOT_NAME = @"bot";
NSString* const BOX_NAME = @"box";
NSString* const BLOCK_NAME = @"block";
NSString* const SPOT_NAME = @"spot";

NSString* const CANMOVE_NAME = @"canmove";
NSString* const CANNOTMOVE_NAME = @"cannotmove";

NSString* const REFRESH = @"refresh";

NSString* const EPISODE_IMG = @"episode";
NSString* const EPISODE_SCREEN_IMG = @"episodeScreen";

NSString* const SPLASHSCREEN_IMG = @"SplashScreen";

//font
NSString* const APP_FONT_NAME = @"angrybirds-regular";

//sound
NSString* const INGAME_SOUND = @"ingame.mp3";
NSString* const MOVE_SOUND = @"move.mp3";
NSString* const RUN_SOUND = @"run.mp3";

const char LEFT = 'L';
const char RIGHT = 'R';
const char UP = 'U';
const char DOWN = 'D';

const float MOVE_DURATION = 0.15;

@synthesize NoOfSpots;


- (id) init {
    if (self = [super init])
        pathFinder = [[PathFinder alloc] init];
    
    return self;
}


//properly get the level from sqlite db
- (LevelDetailItem*) getNextLevelDetailItem: (LevelDetailItem*) curLevel {
    
    if (curLevel == nil) {
        curLevel = [[LevelDetailItem alloc] init];
        curLevel.PackId = 1;
        curLevel.LevelNum = 0;
        NSLog(@"START");
    }
    LevelDetailItem* level = [[DataAccess sharedInstance] getNextLevelDetailItem:curLevel.PackId currentLevel:curLevel.LevelNum];
    NSArray* stringArr = [level.Content componentsSeparatedByString:@"0"];
    
    level.MazeChars = [[NSMutableArray alloc] init];
    for (int i = 0; i < stringArr.count; i++) {
        NSString* line = [stringArr objectAtIndex:i];
        if (line.length > 0)
            [level.MazeChars addObject:line];
    }
    
    return level;
}

//update 'maze' object to the current level maze
- (void) initMaze: (NSMutableArray*) mazeChars {
    
    maze = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mazeChars.count; i++) {
        
        NSString* line = [mazeChars objectAtIndex:i];
        NSMutableArray* rows = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < line.length; j++) {
            char tmpChar = [line characterAtIndex:j];
            int tmpNum = -1;
            
            if (tmpChar == BLOCK_CHAR || tmpChar == BOX_CHAR || tmpChar == BOX_ON_SPOT) {
                tmpNum = -1;
            }
            else {
                tmpNum = 0;
            }
            
            [rows addObject:[NSNumber numberWithInt:tmpNum]];
        }
        [maze addObject:rows];
    }
    
    //TODO: debugging
    //printf("\n\n");
    //[self displayMaze];
}

//based on the current state of the maze, calculate the shortest path to touch position
- (NSString*) getShortestPath: (MatrixPosStruct) pos withBotPos: (MatrixPosStruct) botPos {
    //[self displayMaze];
    NSString* path = [pathFinder getShortestPathString:maze touchPos:pos withBotPos:botPos];
    return path;
}

- (BOOL)checkGameWin: (NSMutableArray*) mazeCharacters {
    BOOL win = NO;
    
    int cntSpot = 0;
    
    for (int i = 0; i < mazeCharacters.count; i++) {
        NSString* line = [mazeCharacters objectAtIndex:i];
        for (int j = 0; j < line.length; j++) {
            if ([line characterAtIndex:j] == BOX_ON_SPOT)
                cntSpot++;
        }
    }
    
    win = (cntSpot == NoOfSpots);
    
    return win;
}

- (void) updateGameWin: (LevelDetailItem*) curLevelItem {
    [[DataAccess sharedInstance] updateGameWin:curLevelItem];
    
}

- (NSMutableArray*) getAllEpisodes {
    return [[DataAccess sharedInstance] getAllEpisodes];
}

//helper
- (void) displayMaze {
    [pathFinder displayMaze: maze];
}
@end

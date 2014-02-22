//
//  GameLogic.h
//  JSokoban
//
//  Created by Jerry on 6/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelDetailItem.h"

typedef struct tagMatrixPos {
    int Row;
    int Col;
}
MatrixPosStruct;

@interface GameLogic : NSObject

//singleton
+ (id) sharedGameLogic;

//const variables
//TODO: convert to char
extern const char BLOCK_CHAR;
extern const char SPOT_CHAR;
extern const char BOT_CHAR;
extern const char BOX_CHAR;
extern const char PATH_CHAR;
extern const char BOX_ON_SPOT;

extern NSString* const BLOCK_IMG;
extern NSString* const SPOT_IMG;
extern NSString* const BOT_IMG;
extern NSString* const BOX_IMG;
extern NSString* const CANMOVE_IMG;
extern NSString* const CANNOTMOVE_IMG;

extern NSString* const SCREEN_IMG;

extern NSString* const UP_IMG;
extern NSString* const UP_NAME;
extern NSString* const DOWN_IMG;
extern NSString* const DOWN_NAME;

//menu
extern NSString* const RESTARTBTN_IMG;
extern NSString* const RESTARTBTN_NAME;

extern NSString* const MENUBTN_IMG;
extern NSString* const MENUBTN_NAME;

extern NSString* const SOUNDONBTN_IMG;
extern NSString* const SOUNDONBTN_NAME;

extern NSString* const HELPBTN_IMG;
extern NSString* const HELPBTN_NAME;

extern NSString* const NEXTBTN_IMG;
extern NSString* const NEXTBTN_NAME;

extern NSString* const BACKBTN_IMG;
extern NSString* const BACKBTN_NAME;

extern NSString* const MENUBAR_IMG;
extern NSString* const MENUBAR_NAME;

extern NSString* const MENU_NAME;
extern NSString* const MENUBG_NAME;

extern NSString* const WINDIALOG_IMG;
extern NSString* const WINDIALOG_NAME;

extern NSString* const ADVENTURE_WINDIALOG_IMG;
extern NSString* const ADVENTURE_WINDIALOG_NAME;


extern NSString* const INSTRUCTION_DIALOG_NAME;
extern NSString* const INSTRUCTION_DIALOG_IMG;

extern NSString* const PAUSE_IMG;
extern NSString* const PAUSE_NAME;


extern NSString* const BOT_NAME;
extern NSString* const BOX_NAME;
extern NSString* const BLOCK_NAME;
extern NSString* const SPOT_NAME;

extern NSString* const CANMOVE_NAME;
extern NSString* const CANNOTMOVE_NAME;

extern NSString* const PATH_OUTBOUND;

extern NSString* const REFRESH;

extern NSString* const EPISODE_IMG;
extern NSString* const EPISODE_SCREEN_IMG;

extern NSString* const LOCK_IMG;

extern NSString* const SPLASHSCREEN_IMG;
extern NSString* const SPLASHSCREEN_NAME;

extern NSString* const APP_FONT_NAME;

//sound
extern NSString* const INGAME_SOUND;
extern NSString* const MOVE_SOUND;
extern NSString* const RUN_SOUND;
extern NSString* const CLAP_SOUND;

extern NSString* const WINGAME_SCREEN_IMG;
extern NSString* const WINGAME_SCREEN_NAME;

extern const char LEFT;
extern const char RIGHT;
extern const char UP;
extern const char DOWN;

extern const float MOVE_DURATION;

@property (nonatomic, assign) int NoOfSpots;

@property (nonatomic, assign) BOOL SOUND_ON;


- (LevelDetailItem*) getNextLevelDetailItem: (LevelDetailItem*) curLevel;

- (LevelDetailItem*) getPrevLevelDetailItem: (LevelDetailItem*) curLevel;

- (void) initMaze: (NSMutableArray*) mazeChars;

- (NSString*) getShortestPath: (MatrixPosStruct) pos withBotPos: (MatrixPosStruct) botPos;

- (BOOL) checkGameWin: (NSMutableArray*) mazeCharacters;

- (void) updateGameWin: (LevelDetailItem*) curLevelItem;

- (void) unlockEpisode: (int) nextPackId;

//0: no  1: last of episode  2: very last
- (int) isLastLevel: (LevelDetailItem*) curLevelItem;

- (NSMutableArray*) getAllEpisodes;

@end



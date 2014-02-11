//
//  GameLogic.h
//  JSokoban
//
//  Created by Jerry on 6/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

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

//menu
extern NSString* const REFRESH_IMG;

extern NSString* const BOT_NAME;
extern NSString* const BOX_NAME;
extern NSString* const BLOCK_NAME;
extern NSString* const SPOT_NAME;

extern NSString* const REFRESH;

extern const char LEFT;
extern const char RIGHT;
extern const char UP;
extern const char DOWN;

extern const float MOVE_DURATION;

@property (nonatomic, assign) int NoOfSpots;


- (NSMutableArray*) getMaze: (int) level;

- (void) initMaze: (NSMutableArray*) mazeChars;

- (NSString*) getShortestPath: (MatrixPosStruct) pos withBotPos: (MatrixPosStruct) botPos;

- (BOOL) checkGameWin: (NSMutableArray*) mazeCharacters;

@end



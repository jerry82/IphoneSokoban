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
extern const char BLOCK_CHAR;
extern const char SPOT_CHAR;
extern const char BOT_CHAR;
extern const char BOX_CHAR;

extern NSString* const BLOCK_IMG;
extern NSString* const SPOT_IMG;
extern NSString* const BOT_IMG;
extern NSString* const BOX_IMG;

extern NSString* const BOT_NAME;

extern const char LEFT;
extern const char RIGHT;
extern const char UP;
extern const char DOWN;

extern const float MOVE_DURATION;


- (NSArray*) getMaze: (int) level;

- (void) initMaze: (NSArray*) mazeChars;

- (NSString*) getShortestPath: (MatrixPosStruct) pos withBotPos: (MatrixPosStruct) botPos;

@end



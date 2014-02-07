//
//  PathFinder.h
//  JSokoban
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLogic.h"

@interface PathFinder : NSObject

//for A* algorithm
extern const int MOVE_COST;

- (NSString*) getShortestPathString: (NSMutableArray*)maze touchPos: (MatrixPosStruct)pos withBotPos: (MatrixPosStruct)botPos;

- (void) displayMaze: (NSMutableArray*) maze;

@end

/*
 * node struct
 */
typedef struct tagJNode {
    int ID;
    int ParentID;
    int HValue;
    int GValue;
    int FValue;
    BOOL IsWall;
    MatrixPosStruct Pos;
}
JNodeStruct;

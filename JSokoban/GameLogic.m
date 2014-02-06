//
//  GameLogic.m
//  JSokoban
//
//  Created by Jerry on 6/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic {
    NSMutableArray* maze;
}

/*
 * const declaration
 */
const char BLOCK_CHAR = '#';
const char SPOT_CHAR = '+';
const char BOT_CHAR = '@';
const char BOX_CHAR = '$';

const NSString* BLOCK_IMG = @"block40";
const NSString* SPOT_IMG = @"spot40";
const NSString* BOT_IMG = @"bot40";
const NSString* BOX_IMG = @"box40";

const char LEFT = 'L';
const char RIGHT = 'R';
const char UP = 'U';
const char DOWN = 'D';

const float MOVE_DURATION = 0.5;


//properly get the level from sqlite db
-(NSArray*) getMaze:(int)level {
    NSArray* mazeChars = [NSArray arrayWithObjects:
                          @"      ####",
                          @"    ###++#",
                          @"    #..++#",
                          @"    #..$.#",
                          @"######.###",
                          @"#@.....###",
                          @"##.#.$.$.#",
                          @" #.$.#.#.#",
                          @" #...#...#",
                          @" #########", nil];
    
    return mazeChars;
}

//update 'maze' object to the current level maze
- (void) initMaze: (NSArray*) mazeChars {
    
    maze = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mazeChars.count; i++) {
        
        NSString* line = [mazeChars objectAtIndex:i];
        NSMutableArray* rows = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < line.length; j++) {
            char tmpChar = [line characterAtIndex:j];
            int tmpNum = -1;
            
            if (tmpChar == ' ' || tmpChar == BLOCK_CHAR || tmpChar == BOX_CHAR) {
                tmpNum = -1;
            }
            else {
                tmpNum = 0;
            }
            
            [rows addObject:[NSNumber numberWithInt:tmpNum]];
        }
        [maze addObject:rows];
    }
}

//based on the current state of the maze, calculate the shortest path to touch position
- (NSString*) getShortestPath:(MatrixPosStruct) pos {
    int row = pos.Row;
    int col = maze.count - pos.Col;
    
    return @"RRRRUUUDDDL";
}
@end

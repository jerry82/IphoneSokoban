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
//const char SPOT_CHAR = '+';
const char SPOT_CHAR = '.';

const char BOT_CHAR = '@';
const char BOX_CHAR = '$';
//const char PATH_CHAR = '.';
const char PATH_CHAR = ' ';
const char BOX_ON_SPOT = 'x';

NSString* const BLOCK_IMG = @"block40";
NSString* const SPOT_IMG = @"spot40";
NSString* const BOT_IMG = @"bot40";
NSString* const BOX_IMG = @"box40";

//menu
NSString* const REFRESH_IMG = @"refresh60";

NSString* const BOT_NAME = @"bot";
NSString* const BOX_NAME = @"box";
NSString* const BLOCK_NAME = @"block";
NSString* const SPOT_NAME = @"spot";

NSString* const REFRESH = @"refresh";

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
-(NSMutableArray*) getMaze:(int)level {
    
    NSString* tmp = [[DataAccess sharedInstance] getLevel:level];
    NSArray* stringArr = [tmp componentsSeparatedByString:@"0"];
    
    NSMutableArray* mazeChars = [[NSMutableArray alloc] init];
    for (int i = 0; i < stringArr.count; i++) {
        NSString* line = [stringArr objectAtIndex:i];
        if (line.length > 0)
            [mazeChars addObject:line];
    }
    
    /*
    NSMutableArray* mazeChars = [NSMutableArray arrayWithObjects:
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
    */
    return mazeChars;
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

//helper
- (void) displayMaze {
    [pathFinder displayMaze: maze];
}
@end

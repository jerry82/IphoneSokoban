//
//  PathFinder.m
//  JSokoban
//
//  Created by Jerry on 7/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "PathFinder.h"


@implementation PathFinder {
    NSMutableDictionary* nodeDict;
    NSMutableArray* myMaze;
    int startNodeId;
    int endNodeId;
    
    NSMutableArray* openList;
    NSMutableArray* closeList;
}

const int MOVE_COST = 5;

-(id) init {
    if (self = [super init]) {

    }
    return self;
}

- (void) reFreshVariables {
    openList = [[NSMutableArray alloc] init];
    closeList = [[NSMutableArray alloc] init];
}

/*
 * main function goes here
 */
- (NSString*) getShortestPathString: (NSMutableArray*)maze touchPos: (MatrixPosStruct)pos withBotPos: (MatrixPosStruct)botPos {
    
    //NSLog(@"%d : %d", pos.Row, pos.Col);
    myMaze = maze;
    
    //out of bound
    if (pos.Row < 0 || pos.Col < 0 || pos.Row >= [self getMazeHeight] || pos.Col >= [self getMazeWidth])
        return @"";
    
    startNodeId = [self getNodeId:botPos.Row andCol:botPos.Col];
    endNodeId = [self getNodeId:pos.Row andCol:pos.Col];
    [self reFreshVariables];
    [self buildNodeDict];

    
    //[self displayHGValues];
    
    NSString* path = [self route];
    return path;
}

/* 
 *  run trace
 */
- (NSString*) route {
    int curId = startNodeId;
    
    while (curId != endNodeId) {
        [closeList addObject:[NSNumber numberWithInt:curId]];
        
        NSMutableArray* neighbors = [self getNeighbors:curId];
        if (neighbors.count > 0)
            [openList addObjectsFromArray:neighbors];
        
        //DEBUG
        //[self showOpenCloseList];
        
        if (openList.count > 0)
            curId = [self popMinFValueNodeId_FromOpenList];
        else
            //no path
            return @"";
    }
    
    NSMutableArray* pathNodes = [[NSMutableArray alloc] init];
    
    int tmpId = endNodeId;
    
    while (tmpId != startNodeId) {
        [pathNodes addObject:[NSNumber numberWithInteger:tmpId]];
        //printf("%d <-- ", tmpId);
        JNodeStruct tmpNode = [self getJNodeFromDict:tmpId];
        tmpId = tmpNode.ParentID;
        if (tmpId == -1) {
            break;
        }
    }
    //printf("%d <-- \n", tmpId);
    [pathNodes addObject:[NSNumber numberWithInteger:tmpId]];
    
    return [self convertPathToString:pathNodes];
}

- (NSString*) convertPathToString: (NSMutableArray*) nodes {
    NSMutableString* path = [[NSMutableString alloc] init];
    
    for (int i = nodes.count - 1; i > 0; i--) {
        int cur = [[nodes objectAtIndex:i] integerValue];
        int next = [[nodes objectAtIndex:i-1] integerValue];
        
        [path appendString:[self getMove:cur To:next]];
    }
    
    return [NSString stringWithString:path];
}

- (NSString*) getMove: (int)from To:(int)to {
    NSString* move = @"L";
    
    MatrixPosStruct curPos = [self getPosOfNodeId:from];
    MatrixPosStruct toPos = [self getPosOfNodeId:to];
    
    if (curPos.Col == toPos.Col) {
        if (toPos.Row > curPos.Row)
            move = @"D";
        else
            move = @"U";
    }
    else if (curPos.Row == toPos.Row) {
        if (toPos.Col > curPos.Col)
            move = @"R";
        else
            move = @"L";
    }
    
    return move;
}

//get 4 neightbor ids
- (NSMutableArray*) getNeighbors: (int) curNodeId {
    NSMutableArray* neighbors = [[NSMutableArray alloc] init];
    
    MatrixPosStruct curPos = [self getPosOfNodeId:curNodeId];
    JNodeStruct curNode = [self getJNodeFromDict:curNodeId];
    
    for (int i = 1; i <= 4; i++) {
        
        MatrixPosStruct neighBorPos;
        switch (i) {
            case 1:
                neighBorPos.Row = curPos.Row - 1;
                neighBorPos.Col = curPos.Col;
                break;
            case 2:
                neighBorPos.Row = curPos.Row + 1;
                neighBorPos.Col = curPos.Col;
                break;
            case 3:
                neighBorPos.Row = curPos.Row;
                neighBorPos.Col = curPos.Col - 1;
                break;
            case 4:
                neighBorPos.Row = curPos.Row;
                neighBorPos.Col = curPos.Col + 1;
                break;
        }

        if ([self withinBound:neighBorPos]) {
            //set parent
            JNodeStruct neighborNode = [self getJNodeFromDict:[self getNodeId:neighBorPos]];
            
            //IGNORE WALL
            if (neighborNode.IsWall)
                continue;
            
            //IGNORE node already in close list
            if ([closeList containsObject:[NSNumber numberWithInt:neighborNode.ID]])
                continue;
            
            //not visited node
            if (neighborNode.GValue == 0) {
                //calculate GCost and FCost of neighbors
                neighborNode.ParentID = curNodeId;
                neighborNode.GValue = curNode.GValue + MOVE_COST;
                neighborNode.FValue = neighborNode.GValue + neighborNode.HValue;
                
                //printf("%d has parent: %d\n", neighborNode.ID, curNodeId);
            }
            //already visted
            else {
                if (curNode.GValue + MOVE_COST < neighborNode.GValue) {
                    //re-parent
                    neighborNode.ParentID = curNodeId;
                    neighborNode.GValue = curNode.GValue + MOVE_COST;
                    neighborNode.FValue = neighborNode.GValue + neighborNode.HValue;
                }
            }
            
            //since we store struct we have to update dict
            [self setJNodeToDict:neighborNode];
            
            //add id to NSMutableArray
            [neighbors addObject:[NSNumber numberWithInt:[self getNodeId:neighBorPos]]];
        }
    }
    
    return neighbors;
}

- (BOOL) withinBound: (MatrixPosStruct)pos {
    if (pos.Row < 0 || pos.Col < 0 || pos.Row >= [self getMazeHeight] || pos.Col >= [self getMazeWidth])
        return NO;
    else
        return YES;
}

/*
 * build a dictionary of nodes
 */
- (void) buildNodeDict {
    
    nodeDict = [[NSMutableDictionary alloc] init];
    
    if (startNodeId < 1 || endNodeId < 1) {
        NSLog(@"start/end Node invalid!");
        return;
    }
    
    int cnt = 1;
    
    for (int i = 0; i < myMaze.count; i++) {
        NSMutableArray* rows = [myMaze objectAtIndex:i];
        for (int j = 0; j < rows.count; j++) {
            
            JNodeStruct node;
            node.ID = cnt;
            
            node.Pos.Row = i;
            node.Pos.Col = j;
            node.GValue = 0;
            node.FValue = 0;
            node.ParentID = -1;
            node.IsWall = NO;
            
            MatrixPosStruct tmpPos = [self getPosOfNodeId:endNodeId];
            node.HValue = abs(tmpPos.Row - i) + abs(tmpPos.Col - j);
            
            if ([[rows objectAtIndex:j] integerValue] == -1) {
                node.IsWall = YES;
                node.HValue = -1;
            }
            
            [self setJNodeToDict:node];
            

            
            cnt++;
        }
    }
}


/*
 * helpers
 */
- (int) getNodeId: (int)row andCol: (int)col {
    return row * [self getMazeWidth] + col + 1 ;
}

- (int) getNodeId: (MatrixPosStruct) pos {
    return pos.Row * [self getMazeWidth] + pos.Col + 1 ;
}

- (MatrixPosStruct) getPosOfNodeId: (int) nodeId {
    MatrixPosStruct pos;
    int width = [self getMazeWidth];
    
    if (nodeId % width == 0)
        pos.Row = nodeId / width - 1;
    else
        pos.Row = nodeId / width;
    pos.Col = (nodeId - 1) % [self getMazeWidth];
    
    return pos;
}

- (int) popMinFValueNodeId_FromOpenList {
    int returnId = -1;
    
    if (openList.count > 0) {
        int minValue = INT16_MAX;
        for (int i = 0; i < openList.count; i++) {
            int nodeId = [[openList objectAtIndex:i] integerValue];
            JNodeStruct jnode = [self getJNodeFromDict:nodeId];
            if (minValue > jnode.FValue) {
                returnId = nodeId;
                minValue = jnode.FValue;
            }
        }
        
        //remove the found id
        [openList removeObject:[NSNumber numberWithInt:returnId]];
    }
    
    return returnId;
}

- (void) showOpenCloseList {
    printf("OPENLIST:\n");
    for (int i = 0; i < openList.count; i++) {
        int tmpId = [[openList objectAtIndex:i] integerValue];
        int parentId = [self getJNodeFromDict:tmpId].ParentID;
        printf("%d|%d , ", tmpId, parentId);
    }
    printf("\n");
    printf("CLOSELIST:\n");
    for (int i = 0; i < closeList.count; i++) {
        printf("%d , ", [[closeList objectAtIndex:i] integerValue]);
    }
    printf("\n");
}

-(int) getMazeHeight {
    if (myMaze != nil)
        return myMaze.count;
    else
        return -1;
}

-(int) getMazeWidth {
    if (myMaze != nil) {
        NSMutableArray* rows = [myMaze objectAtIndex:0];
        return rows.count;
    }
    return -1;
}

- (void) displayHGValues {
    int size = [self getMazeHeight] * [self getMazeWidth];
    
    for (int i = 1; i <= size; i++) {
        JNodeStruct jnode = [self getJNodeFromDict:i];
        printf("%d,%d\t", jnode.HValue, jnode.GValue);
        
        if (i % [self getMazeWidth] == 0) {
            printf("\n");
        }
    }
}
- (void) setJNodeToDict: (JNodeStruct) jnode {
    NSValue* nodeObj = [NSValue value:&jnode withObjCType:@encode(JNodeStruct)];
    [nodeDict setObject:nodeObj forKey:[NSString stringWithFormat:@"%d", jnode.ID]];
}

- (JNodeStruct) getJNodeFromDict: (int)i {
    
    NSString* idString = [NSString stringWithFormat:@"%d", i];
    JNodeStruct jnode;
    NSValue* nodeValue = [nodeDict objectForKey:idString];
    [nodeValue getValue:&jnode];
    
    return jnode;
}

- (void) displayMaze: (NSMutableArray*) maze {
    for (int i = 0; i < maze.count; i++) {
        NSMutableArray* rows = [maze objectAtIndex:i];
        for (int j = 0; j < rows.count; j++) {
            int tmp = [[rows objectAtIndex:j] integerValue];
            if (tmp == -1)
                printf("|\t");
            else
                printf("%d\t", tmp);
        }
        printf("\n");
    }
}

@end

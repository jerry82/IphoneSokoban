//
//  MyScene.m
//  JSokoban
//
//  Created by Jerry on 27/1/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "MyScene.h"
#import "GameLogic.h"
#import "ViewController.h"

@implementation MyScene {
    int Sprite_Edge;
    int Pad_Bottom_Screen;
    GameLogic* shareGameLogic;
    BOOL botMoving;
    NSMutableArray* mazeChars;
    
    NSMutableArray* spriteBag;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //calculate Sprite's edge
        Sprite_Edge = 40;
        Pad_Bottom_Screen = 40;
        
        printf("%f %f", size.height, size.width);
        
        shareGameLogic = [GameLogic sharedGameLogic];

        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        //self.backgroundColor = [SKColor colorWithRed:(float)242/255 green:(float)236/255 blue:(float)212/255 alpha:1];
        self.backgroundColor = [SKColor colorWithRed:(float)185/255 green:(float)233/255 blue:(float)255/255 alpha:1];
        
        
        spriteBag = [[NSMutableArray alloc] init];
        
        [self createMenu];
    }
    
    return self;
}


//MARK: MENU here
- (void) createMenu {
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"screen.png"];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    //background.scale = 0.75;
    [self addChild:background];
    
    //add refresh node
    SKSpriteNode* refreshBtn = [SKSpriteNode spriteNodeWithImageNamed:REFRESH_IMG];
    refreshBtn.position = CGPointMake(self.size.width - refreshBtn.size.width / 2, self.size.height - refreshBtn.size.height);
    refreshBtn.name = REFRESH;
    
    [self addChild:refreshBtn];
    
    //TODO: to change
    //next button
    SKSpriteNode* nextBtn = [SKSpriteNode spriteNodeWithImageNamed:@"back50"];
    nextBtn.position = CGPointMake(nextBtn.size.width/2, self.size.height - nextBtn.size.height);
    nextBtn.name = @"NEXT_LEVEL";
    nextBtn.zPosition = 10;
    [self addChild:nextBtn];
}



-(void) createMaze: (NSMutableArray*) newMaze {
    
    botMoving = NO;
    
    //mazeChars = [self.userData objectForKey:@"maze"];
    mazeChars = [NSMutableArray arrayWithArray:newMaze];
    
    //resize sprite base on the width of maze
    //TODO: convert newEdge to float value, detect screen width in runtime
    NSString* line = [mazeChars objectAtIndex:0];
    int newEdge = 320 / line.length;
    float scale = (float)newEdge / Sprite_Edge;
    Sprite_Edge = newEdge;
    
    NSLog(@"%f", scale);
    
    //init maze in gameLogic
    [shareGameLogic initMaze:mazeChars];
    
    int boxCnt = 1;
    int cntSpot = 0;
    
    //draw maze on board
    for (int i = (int)mazeChars.count - 1; i >= 0; i--) {
        NSString* line = (NSString*)mazeChars[i];
        for (int j = 0; j < line.length; j++) {
            
            if ([line characterAtIndex:j] == ' ') continue;
            
            SKSpriteNode* blockSprite;
            
            if ([line characterAtIndex:j] == BLOCK_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BLOCK_IMG];
                blockSprite.name = BLOCK_NAME;
            }
            else if ([line characterAtIndex:j] == SPOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:SPOT_IMG];
                blockSprite.name = SPOT_NAME;
                //below others
                [blockSprite setZPosition:0];
                cntSpot++;
            }
            else if ([line characterAtIndex:j] == BOX_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BOX_IMG];
                blockSprite.name = [NSString stringWithFormat:@"box_%d", boxCnt++];
                [blockSprite setZPosition:1];
            }
            else if ([line characterAtIndex:j] == BOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BOT_IMG];
                blockSprite.name = BOT_NAME;
                [blockSprite setZPosition:1];
            }
            
            if (blockSprite != nil) {
                float x = j * Sprite_Edge + Sprite_Edge/2;
                float y = Pad_Bottom_Screen + (mazeChars.count - i) * Sprite_Edge - Sprite_Edge / 2;
                //NSLog(@"%f %f", x, y);
                blockSprite.position = CGPointMake(x, y);
                blockSprite.scale = scale;
                
                //add to bag
                [spriteBag addObject:blockSprite];
                [self addChild:blockSprite];
            }
        }
    }
    
    //set criteria for win game
    shareGameLogic.NoOfSpots = cntSpot;
}


/*
 *  Make the BOT move
 *  path array contains sequence of movement: L: Left, R: Right, U: Up, D: Down
 *  iterate through the input path string to create a movement of a sprite
 */
-(void) moveBot: (NSString*) path{
    
    //search bot
    SKNode* myBot = [self childNodeWithName:BOT_NAME];
    if (myBot == nil || [path length] == 0) {
        return;
    }
    MatrixPosStruct botOldLocation = [self getMatrixPos:myBot.position];
    
    NSMutableArray* moves = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < path.length; i++) {
        SKAction* aMove = [[SKAction alloc] init];
        SKAction* flipAction = [[SKAction alloc] init];
        
        char tmpChar = [path characterAtIndex:i];
        switch (tmpChar) {
            case 'L': {
                    flipAction = [SKAction runBlock:^{
                        myBot.xScale = -1;
                    }];
                
                [moves addObject:flipAction];

                aMove = [SKAction moveByX:-1 * Sprite_Edge y:0 duration:MOVE_DURATION];
                break;
            }
            case 'R': {
                flipAction = [SKAction runBlock:^{
                    myBot.xScale = 1;
                }];
                [moves addObject:flipAction];

                aMove = [SKAction moveByX:Sprite_Edge y:0 duration:MOVE_DURATION];
                break;
            }
            case 'U': {
                aMove = [SKAction moveByX:0 y:Sprite_Edge duration:MOVE_DURATION];
                break;
            }
            case 'D': {
                aMove = [SKAction moveByX:0 y:-1 * Sprite_Edge duration:MOVE_DURATION];
                break;
            }
        }
        
        if (flipAction != nil) {
            
        }
        [moves addObject:aMove];

    }
    
    NSArray* moveArray = [[NSArray alloc] initWithArray:moves];
    SKAction* moveSequence = [SKAction sequence:moveArray];
    botMoving = YES;
    
    [myBot runAction:moveSequence completion:^{[self botStop: botOldLocation];}];
}
-(void) botStop: (MatrixPosStruct) botOldLocation {
    //MARK: for debugging
    //MatrixPosStruct botPos = [self getMatrixPos:[self getBotLocation]];
    //printf("stop location : %d,%d\n", botPos.Row, botPos.Col);
    //NSLog(@"bot Stop");
    botMoving = NO;
}

/*
 * handle touch event
 */
// !!!: main handler for touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //check buttons touched
        SKNode* tmpNode = [self nodeAtPoint:location];
        if (tmpNode.name != nil) {
            if (tmpNode.name == REFRESH) {
                [self refreshLevel];
                return;
            }
            else if ([tmpNode.name  isEqual: @"NEXT_LEVEL"]) {
                [self nextLevel];
                return;
            }
        }
        
        if (botMoving){
            break;
        }
        
        //SKNode* touchNode = [self nodeAtPoint:location];
        NSArray* touchNodeArr = [self nodesAtPoint:location];
        //NSLog(@"%@", touchNode.name);
        
        BOOL isEmptyPlace = YES;
        for (int i = 0; i < touchNodeArr.count; i++) {
            SKNode* touchNode = [touchNodeArr objectAtIndex:i];
            if (touchNode.name != nil) {
                if (touchNode.name == BLOCK_NAME) {
                    isEmptyPlace = NO;
                    break;
                }
                else {
                    NSRange range = [touchNode.name rangeOfString:@"box"];
                    if (range.location != NSNotFound) {
                        [self moveTheBox:touchNode.name];
                        isEmptyPlace = NO;
                        //only 1 box
                        break;
                    }
                }
            }
        }
        
        if (isEmptyPlace) {
            MatrixPosStruct touchPos = [self getMatrixPos:location];
            MatrixPosStruct botPos = [self getMatrixPos:[self getBotLocation]];
            
            printf("bot location: %d,%d ---> %d,%d\n", botPos.Row, botPos.Col, touchPos.Row, touchPos.Col);
            
            //if the 'boxes' are not touched
            NSString* path = [shareGameLogic getShortestPath:touchPos withBotPos:botPos];
            [self moveBot:path];
        }

        //handle 1 touch
        break;
    }
}

-(void) moveTheBox: (NSString*) boxName {
    //find the box
    SKNode* box = [self childNodeWithName:boxName];
    if (box != nil) {
        //find any box around
        MatrixPosStruct botLocation = [self getMatrixPos:[self getBotLocation]];
        MatrixPosStruct boxLocation = [self getMatrixPos:box.position];
        
        NSString* moveSymbol = @"";
        
        //TODO: to change the hardcode character
        if (botLocation.Row == boxLocation.Row) {
            //both should: LEFT
            if (botLocation.Col - boxLocation.Col == 1) {
                if (![self boxHitWall:boxLocation.Row :boxLocation.Col - 1]) {
                    moveSymbol = @"L";
                }
            }
            //RIGHT
            else if (boxLocation.Col - botLocation.Col == 1) {
                if (![self boxHitWall:boxLocation.Row :boxLocation.Col + 1]) {
                    moveSymbol = @"R";
                }
            }
        }
        else if (botLocation.Col == boxLocation.Col) {
            if (botLocation.Row - boxLocation.Row == 1) {
                if (![self boxHitWall:boxLocation.Row - 1 :boxLocation.Col]) {
                    moveSymbol = @"U";
                }
            }
            else if (boxLocation.Row - botLocation.Row == 1) {
                if (![self boxHitWall:boxLocation.Row + 1 :boxLocation.Col]) {
                    moveSymbol = @"D";
                }
            }
        }
        
        if ([moveSymbol length] > 0) {
            SKAction* aMove = [[SKAction alloc] init];
            
            char tmpChar = [moveSymbol characterAtIndex:0];
            switch (tmpChar) {
                case 'L':
                    aMove = [SKAction moveByX:-1 * Sprite_Edge y:0 duration:MOVE_DURATION];
                    break;
                case 'R':
                    aMove = [SKAction moveByX:Sprite_Edge y:0 duration:MOVE_DURATION];
                    break;
                case 'U':
                    aMove = [SKAction moveByX:0 y:Sprite_Edge duration:MOVE_DURATION];
                    break;
                case 'D':
                    aMove = [SKAction moveByX:0 y:-1 * Sprite_Edge duration:MOVE_DURATION];
                    break;
            }
            
            SKNode* myBot = [self childNodeWithName:BOT_NAME];
            botMoving = YES;
            [myBot runAction:aMove];
            [box runAction:aMove completion:^{[self updateMazeWithNewBoxLocation: box : boxLocation];}];
        }
    }
}

/*
 * update maze that change after the box is moving
 * also check for Win game
 */
- (void) updateMazeWithNewBoxLocation: (SKNode*) box :(MatrixPosStruct) boxOldLocation {
    MatrixPosStruct boxNewLocation = [self getMatrixPos:box.position];
    char replaceChar;
    
    //update mazeChars
    NSString* line = [mazeChars objectAtIndex:boxOldLocation.Row];
    //if move out from the previous spot
    //update the old position with spot char
    if ([line characterAtIndex:boxOldLocation.Col] == BOX_ON_SPOT) {
        replaceChar = SPOT_CHAR;
    }
    //else with path char
    else
        replaceChar = PATH_CHAR;
    NSString* newstring = [line stringByReplacingCharactersInRange:NSMakeRange(boxOldLocation.Col, 1)
                                                         withString:[NSString stringWithFormat:@"%c", replaceChar]];
    [mazeChars removeObjectAtIndex:boxOldLocation.Row];
    [mazeChars insertObject:newstring atIndex:boxOldLocation.Row];
    
    //set wall
    NSString* line2 = [mazeChars objectAtIndex:boxNewLocation.Row];
    
    //if the next position is SPOT, replaceChar would be boxOnSpot
    //else replaceChar should be box char
    if ([line2 characterAtIndex:boxNewLocation.Col] == SPOT_CHAR){
        replaceChar = BOX_ON_SPOT;
    }
    else
        replaceChar = BOX_CHAR;
    
    NSString* newstring2 = [line2 stringByReplacingCharactersInRange:NSMakeRange(boxNewLocation.Col, 1)
                                                          withString:[NSString stringWithFormat:@"%c", replaceChar]];
    [mazeChars removeObjectAtIndex:boxNewLocation.Row];
    [mazeChars insertObject:newstring2 atIndex:boxNewLocation.Row];
    
    //MARK: to diplayMazeChars for debugging
    [self displayMazeChars];
    
    BOOL win = [shareGameLogic checkGameWin:mazeChars];
    //TODO: need to put mazeChars to getShortestPath function
    if (!win) {
        [shareGameLogic initMaze:mazeChars];
        botMoving = NO;
    }
    else {
        [self handleGameWin];
    }
}

- (void) handleGameWin {
    NSLog(@"game is win");
}

- (void) refreshLevel {
    [self.viewController createNewScene:1];
}

//TODO: to test
- (void) nextLevel {
    [self.viewController createNewScene:self.CurrentLevel + 1];
    NSLog(@"next level %d", self.CurrentLevel + 1);
}

//TODO: for debugging
- (void) displayMazeChars {
    for (int i = 0; i < mazeChars.count; i++) {
        NSString* line = [mazeChars objectAtIndex:i];
        NSLog(@"%@", line);
    }
}

- (BOOL) boxHitWall: (int) row : (int) col {

    MatrixPosStruct left;
    left.Row = row;
    left.Col = col;
    CGPoint point = [self getCGPoint:left];
    
    NSArray* nodeArr = [self nodesAtPoint:point];
    for (int i = 0; i < nodeArr.count; i++) {
        SKNode* node = [nodeArr objectAtIndex:i];
        NSLog(@"hitwith: %@", node.name);
        if (node.name == nil) continue;
        
        if (node.name == BLOCK_NAME) {
            return YES;
        }
        else {
            if ([node.name rangeOfString:BOX_NAME].location != NSNotFound)
                return YES;
        }
    }
    return NO;
}

#pragma mark helpers

/*
 * translate actual touch coordinate to position in 2D array
 * ---> topleft point of the Array is 0,0
 */
-(MatrixPosStruct) getMatrixPos: (CGPoint) point {
    MatrixPosStruct pos;
    pos.Col = (int)(point.x / Sprite_Edge);
    pos.Row = (int)((point.y - Pad_Bottom_Screen) / Sprite_Edge) + 1;
    
    pos.Row = (int)mazeChars.count - pos.Row;
    return pos;
}

/*
 * translate matrix row,col to anchor CGPoint
 */
- (CGPoint) getCGPoint: (MatrixPosStruct) pos {

    float x = pos.Col * Sprite_Edge + Sprite_Edge/2;
    float y = Pad_Bottom_Screen + (mazeChars.count - pos.Row) * Sprite_Edge - Sprite_Edge / 2;
    
    printf("up:%f, %f", x, y);
    return CGPointMake(x, y);
}

/*
 *  retrieve the current location of the BOT
 */
-(CGPoint) getBotLocation {
    
    SKNode* myBot = [self childNodeWithName:BOT_NAME];
    if (myBot != nil) {
        return myBot.position;
    }
    
    return CGPointMake(-1, -1);
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

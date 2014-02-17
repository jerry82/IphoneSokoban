//
//  MyScene.m
//  JSokoban
//
//  Created by Jerry on 27/1/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameScene.h"
#import "GameLogic.h"
#import "ViewController.h"
#import "MenuNode.h"
#import "SoundController.h"

@implementation GameScene {
    int Sprite_Edge;
    int Pad_Bottom_Screen;
    GameLogic* shareGameLogic;
    BOOL botMoving;
    NSMutableArray* mazeChars;
    float spriteScale;
    SoundController* soundController;
}

@synthesize LevelDetail;

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
        //self.backgroundColor = [SKColor colorWithRed:(float)185/255 green:(float)233/255 blue:(float)255/255 alpha:1];
        soundController = [[SoundController alloc] initWithSound];
        
        [self createMenu];
    }
    
    return self;
}


//MARK: MENU here
- (void) createMenu {
    
    //add background
    //TODO: to randomly select background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:SCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    [self addChild:background];
    
    //add pause to show menu
    SKSpriteNode* pauseBtn = [SKSpriteNode spriteNodeWithImageNamed:PAUSE_IMG];
    pauseBtn.position = CGPointMake(pauseBtn.size.width / 2, self.size.height - pauseBtn.size.height);
    pauseBtn.name = PAUSE_NAME;
    pauseBtn.zPosition = 10;
    [self addChild:pauseBtn];
    
    //TODO: this is for debugging
    //next button
    SKSpriteNode* nextBtn = [SKSpriteNode spriteNodeWithImageNamed:NEXTBTN_IMG];
    nextBtn.position = CGPointMake(self.size.width - nextBtn.size.width / 2, self.size.height - nextBtn.size.height);
    nextBtn.name = NEXTBTN_NAME;
    nextBtn.zPosition = 10;
    [self addChild:nextBtn];
    
    SKSpriteNode* backBtn = [SKSpriteNode spriteNodeWithImageNamed:BACKBTN_IMG];
    backBtn.position = CGPointMake(nextBtn.position.x - 5 - backBtn.size.width, nextBtn.position.y);
    backBtn.name = BACKBTN_NAME;
    backBtn.zPosition = 10;
    [self addChild:backBtn];
    

    SKLabelNode* levelText = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    levelText.name = @"LEVEL";
    levelText.fontSize = 35;
    levelText.fontColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    levelText.position = CGPointMake(self.size.width / 2, self.size.height -
                                     pauseBtn.size.height);
    levelText.zPosition = 10;
    [self addChild:levelText];
    
}

-(void) createMaze: (NSMutableArray*) newMaze {
    
    //printf("Current pack-level is: %d\n", self.LevelDetail.PackId, self.LevelDetail.LevelNum);
    //create packID-level text
    SKLabelNode* levelText = (SKLabelNode*)[self childNodeWithName:@"LEVEL"];
    if (levelText != nil) {
        levelText.text = [NSString stringWithFormat:@"%d-%d", self.LevelDetail.PackId, self.LevelDetail.LevelNum];
    }
    
    botMoving = NO;
    
    //mazeChars = [self.userData objectForKey:@"maze"];
    mazeChars = [NSMutableArray arrayWithArray:newMaze];
    
    //resize sprite base on the width of maze
    //TODO: convert newEdge to float value, detect screen width in runtime
    
    int width = 0;
    for (NSMutableString* line in mazeChars) {
        if (width < line.length) {
            width = (int)line.length;
        }
    }
    
    //should fill short line
    for (int j = 0; j < mazeChars.count; j++) {
        NSMutableString* line = [mazeChars objectAtIndex:j];
        NSString* newline = ([line stringByPaddingToLength:width withString:@" " startingAtIndex:0]);
        [mazeChars setObject:newline atIndexedSubscript:j];
        
    }
    
    int newEdge = 320 / width;
    spriteScale = (float)newEdge / Sprite_Edge;
    Sprite_Edge = newEdge;
    
    NSLog(@"%f", spriteScale);
    
    //TODO: debug purpose
    [self displayMazeChars];
    
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
            SKSpriteNode* blockSprite_2;
            
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
            else if ([line characterAtIndex:j] == BOX_ON_SPOT) {
                //1. create spot
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:SPOT_IMG];
                blockSprite.name = SPOT_NAME;
                //below others
                [blockSprite setZPosition:0];
                cntSpot++;
                
                //2. create box
                blockSprite_2 = [SKSpriteNode spriteNodeWithImageNamed:BOX_IMG];
                blockSprite_2.name = [NSString stringWithFormat:@"box_%d", boxCnt++];
                [blockSprite_2 setZPosition:1];
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
                blockSprite.scale = spriteScale;
                [self addChild:blockSprite];
                
                if (blockSprite_2 != nil) {
                    blockSprite_2.position = CGPointMake(x, y);
                    blockSprite_2.scale = spriteScale;
                    [self addChild:blockSprite_2];
                    blockSprite_2 = nil;
                }
            }
        }
    }
    
    //set criteria for win game
    shareGameLogic.NoOfSpots = cntSpot;
    
    //play sound
    [soundController playBackgroundMusic];
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
        
        //TODO: to check the sprite position again
        //if already left, don't flip left
        switch (tmpChar) {
            case 'L': {
                    flipAction = [SKAction runBlock:^{
                        myBot.xScale = -1 * spriteScale;
                    }];
                
                [moves addObject:flipAction];

                aMove = [SKAction moveByX:-1 * Sprite_Edge y:0 duration:MOVE_DURATION];
                break;
            }
            case 'R': {
                flipAction = [SKAction runBlock:^{
                    myBot.xScale = 1 * spriteScale;
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
    
    [soundController playRunSound];
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
    //TODO: bring to other function
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([self handleTouchMenu:location]) {
            return;
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
            if (path.length > 0 && ![path isEqualToString:PATH_OUTBOUND]) {
                [self showDestinationIcon:touchPos canMove:YES];
                [self moveBot:path];
            }
            else if (![path isEqualToString:PATH_OUTBOUND])
                [self showDestinationIcon:touchPos canMove:NO];
        }

        //handle 1 touch
        break;
    }
}


//MARK: menu handlers
-(BOOL) handleTouchMenu: (CGPoint) location {
    
    //check buttons touched
    //handle following the hierrachy top down
    SKNode* tmpNode = [self nodeAtPoint:location];
    if (tmpNode.name != nil) {
        NSLog(@"touch node: %@", tmpNode.name);
        
        if ([tmpNode.name isEqual: MENUBTN_NAME]) {
            NSLog(@"back to Main menu");
            [self.viewController createEpisodeScene];
            [self hideMenu];
            [self hideWinDialog];
            
            return YES;
        }
        else if ([tmpNode.name isEqual:RESTARTBTN_NAME]) {
            [self restartLevel];
            return YES;
        }
        else if ([tmpNode.name isEqual:SOUNDONBTN_NAME]) {
            if (soundController.SoundEnabled) {
                [soundController stopBackgroundMusic];
            }
            else {
                [soundController playBackgroundMusic];
            }
            return YES;
        }
        else if ([tmpNode.name isEqual:PAUSE_NAME]) {
            [self showMenu];
            return YES;
        }
        else if ([tmpNode.name isEqual:MENUBG_NAME] || [tmpNode.name isEqual:MENUBAR_NAME]) {
            [self hideMenu];
            return YES;
        }
        else if ([tmpNode.name isEqual:NEXTBTN_NAME]) {
            [self nextLevel];
            return YES;
        }
        else if ([tmpNode.name isEqual:BACKBTN_NAME]) {
            [self previousLevel];
            return YES;
        }
    }
    
    return NO;
}

-(void) showMenu {
    SKNode* menu = [self childNodeWithName:MENU_NAME];
    
    if (menu == nil) {
        
        CGPoint pos = CGPointMake(self.size.width/ 2, self.size.height/2);
        menu = [[MenuNode alloc] initMenuWithPos:pos andSize: (self.size)];
        menu.name = MENU_NAME;
        menu.zPosition = 10;
        [self addChild:menu];
    }
}

-(void) hideMenu {
    SKNode* menu = [self childNodeWithName:MENU_NAME];
    if (menu != nil) {
        [menu removeAllChildren];
        [menu removeFromParent];
    }
}

- (void) showWinDialog {
    SKNode* winDialog = [self childNodeWithName:WINDIALOG_NAME];
    
    if (winDialog == nil) {
        CGPoint pos = CGPointMake(self.size.width/2, self.size.height/2);
        winDialog = [[MenuNode alloc] initDialogWithPos:pos andSize:self.size];
        winDialog.name = WINDIALOG_NAME;
        winDialog.zPosition = 10;
        [self addChild: winDialog];
    }
}

-(void) hideWinDialog {
    SKNode* dialog = [self childNodeWithName:WINDIALOG_NAME];
    if (dialog != nil) {
        [dialog removeAllChildren];
        [dialog removeFromParent];
    }
}



-(void) showDestinationIcon: (MatrixPosStruct) mpos canMove: (BOOL)canMove {
    
    NSString* tmpIMG = [[NSString alloc] init];
    NSString* tmpName = [[NSString alloc] init];
    if (canMove == TRUE) {
        tmpIMG = CANMOVE_IMG;
        tmpName = CANMOVE_NAME;
    }
    else {
        tmpIMG = CANNOTMOVE_IMG;
        tmpName = CANNOTMOVE_NAME;
    }
    
    SKNode* sprite = [self childNodeWithName:tmpName];
    if (sprite == nil) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:tmpIMG];
        sprite.name = CANNOTMOVE_NAME;
        sprite.scale = spriteScale;
        sprite.position = [self getCGPoint:mpos];
        [self addChild:sprite];
        
        SKAction* pause = [SKAction waitForDuration:0.3];
        SKAction* remove = [SKAction removeFromParent];
        SKAction* sequence = [SKAction sequence:@[pause, remove]];
        
        [sprite runAction:sequence];
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
            SKAction* flip = [[SKAction alloc] init];
            SKNode* myBot = [self childNodeWithName:BOT_NAME];
            
            char tmpChar = [moveSymbol characterAtIndex:0];
            switch (tmpChar) {
                case 'L': {
                    aMove = [SKAction moveByX:-1 * Sprite_Edge y:0 duration:MOVE_DURATION];
                    flip = [SKAction runBlock:^{
                        myBot.xScale = -1 * spriteScale;
                    }];
                    break;
                }
                case 'R': {
                    aMove = [SKAction moveByX:Sprite_Edge y:0 duration:MOVE_DURATION];
                    flip = [SKAction runBlock:^{
                        myBot.XScale = 1 * spriteScale;
                    }];
                    break;
                }
                case 'U':
                    aMove = [SKAction moveByX:0 y:Sprite_Edge duration:MOVE_DURATION];
                    break;
                case 'D':
                    aMove = [SKAction moveByX:0 y:-1 * Sprite_Edge duration:MOVE_DURATION];
                    break;
            }
            
            
            botMoving = YES;
            SKAction* botSeq = [SKAction sequence:@[flip, aMove]];
            
            [soundController playMoveSound];
            [myBot runAction:botSeq];
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
    
    //update completed level
    [[GameLogic sharedGameLogic] updateGameWin:self.LevelDetail];
    [self showWinDialog];
}

- (void) restartLevel {
    self.LevelDetail.LevelNum--;
    [self.viewController createNewScene: self.LevelDetail chooseNext:YES];
}

//TODO: to test
- (void) nextLevel {
    [self.viewController createNewScene:self.LevelDetail chooseNext:YES];
}

- (void) previousLevel {
    [self.viewController createNewScene:self.LevelDetail chooseNext:NO];
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

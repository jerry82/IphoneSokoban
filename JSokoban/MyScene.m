//
//  MyScene.m
//  JSokoban
//
//  Created by Jerry on 27/1/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "MyScene.h"
#import "GameLogic.h"

@implementation MyScene {
    int Sprite_Edge;
    int Pad_Bottom_Screen;
    GameLogic* shareGameLogic;
    BOOL botMoving;
}


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //calculate Sprite's edge
        Sprite_Edge = 40;
        Pad_Bottom_Screen = 40;
        
        //gameLogic = [[GameLogic alloc] init];
        shareGameLogic = [GameLogic sharedGameLogic];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        botMoving = NO;
        
    }
    return self;
}


-(void) createMaze {
    NSArray* mazeChars = [self.userData objectForKey:@"maze"];
    
    //resize sprite base on the width of maze
    //TODO: convert newEdge to float value
    NSString* line = [mazeChars objectAtIndex:0];
    int newEdge = 320 / line.length;
    float scale = (float)newEdge / Sprite_Edge;
    Sprite_Edge = newEdge;
    
    NSLog(@"%f", scale);
    
    //init maze in gameLogic
    [shareGameLogic initMaze:mazeChars];
    
    //draw maze on board
    for (int i = (int)mazeChars.count - 1; i >= 0; i--) {
        NSString* line = (NSString*)mazeChars[i];
        for (int j = 0; j < line.length; j++) {
            
            if ([line characterAtIndex:j] == ' ') continue;
            
            SKSpriteNode* blockSprite;
            
            if ([line characterAtIndex:j] == BLOCK_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BLOCK_IMG];
            }
            else if ([line characterAtIndex:j] == SPOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:SPOT_IMG];
            }
            else if ([line characterAtIndex:j] == BOX_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BOX_IMG];
            }
            else if ([line characterAtIndex:j] == BOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:BOT_IMG];
                blockSprite.name = BOT_NAME;
            }
            
            if (blockSprite != nil) {
                float x = j * Sprite_Edge + Sprite_Edge/2;
                float y = Pad_Bottom_Screen + (mazeChars.count - i) * Sprite_Edge - Sprite_Edge / 2;
                //NSLog(@"%f %f", x, y);
                blockSprite.position = CGPointMake(x, y);
                blockSprite.scale = scale;
                
                [self addChild:blockSprite];
            }
        }
    }
}

/*
 * update state of maze
 */
- (void)updateMaze {
    
}

/*
 *  translate row, col to actual screen coordinate
 */
-(CGPoint)translateCoord: (int) row :(int) col {
    return CGPointMake(0.0, 0.0);
}

/*
 * translate actual touch coordinate to position in 2D array
 * ---> 0,0 is at bottom left screen
 */
-(MatrixPosStruct) getMatrixPos: (CGPoint) point {
    MatrixPosStruct pos;
    pos.Col = (int)(point.x / Sprite_Edge);
    pos.Row = (int)((point.y - Pad_Bottom_Screen) / Sprite_Edge) + 1;
    return pos;
}


/*
 *  Make the BOT move
 *  path array contains sequence of movement: L: Left, R: Right, U: Up, D: Down
 *  iterate through the input path string to create a movement of a sprite
 */
-(void) moveBot: (NSString*) path{
    
    //search bot
    SKNode* myBot = [self childNodeWithName:BOT_NAME];
    if (myBot == nil || path == @"") {
        return;
    }
    
    
    NSMutableArray* moves = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < path.length; i++) {
        SKAction* aMove = [[SKAction alloc] init];
        
        char tmpChar = [path characterAtIndex:i];
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
        [moves addObject:aMove];
    }
    
    NSArray* moveArray = [[NSArray alloc] initWithArray:moves];
    SKAction* moveSequence = [SKAction sequence:moveArray];
    botMoving = YES;
    [myBot runAction:moveSequence completion:^{[self botStop];}];
}

-(void) botStop {
    botMoving = NO;
    MatrixPosStruct botPos = [self getMatrixPos:[self getBotLocation]];
    printf("stop location : %d,%d\n", botPos.Row, botPos.Col);
    NSLog(@"bot Stop");
    //calculate latest bot coordinate
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

/*
 * handle touch event
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (botMoving){
            break;
        }
        
        MatrixPosStruct touchPos = [self getMatrixPos:location];
        MatrixPosStruct botPos = [self getMatrixPos:[self getBotLocation]];
        
        printf("bot location: %d,%d ---> %d,%d\n", botPos.Row, botPos.Col, touchPos.Row, touchPos.Col);
        
        //if the 'boxes' are not touched
        NSString* path = [shareGameLogic getShortestPath:touchPos withBotPos:botPos];
        [self moveBot:path];


        //handle 1 touch
        break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

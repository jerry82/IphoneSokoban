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
    GameLogic* gameLogic;
}


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //calculate Sprite's edge
        Sprite_Edge = 40;
        Pad_Bottom_Screen = 40;
        
        gameLogic = [[GameLogic alloc] init];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        /*
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
         */
    }
    return self;
}

-(void) setGameLogic:(GameLogic *)input {
    gameLogic = input;
}



-(void) buildDigitalMaze : (NSArray*) mazeChars {
    
}

-(void) createMaze {
    NSArray* mazeChars = [self.userData objectForKey:@"maze"];
    
    [gameLogic initMaze:mazeChars];
    
    for (int i = (int)mazeChars.count - 1; i >= 0; i--) {
        NSString* line = (NSString*)mazeChars[i];
        for (int j = 1; j < line.length; j++) {
            
            if ([line characterAtIndex:j] == ' ') continue;
            
            SKSpriteNode* blockSprite;
            
            if ([line characterAtIndex:j] == BLOCK_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"block40"];
            }
            else if ([line characterAtIndex:j] == SPOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"spot40"];
            }
            else if ([line characterAtIndex:j] == BOX_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"box40"];
            }
            else if ([line characterAtIndex:j] == BOT_CHAR) {
                blockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"bot40"];
                blockSprite.name = @"bot";
            }
            
            if (blockSprite != nil) {
                float x = j * Sprite_Edge - Sprite_Edge/2;
                float y = Pad_Bottom_Screen + (mazeChars.count - i) * Sprite_Edge - Sprite_Edge / 2;
                //NSLog(@"%f %f", x, y);
                blockSprite.position = CGPointMake(x, y);
                
                [self addChild:blockSprite];
            }
        }
    }
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
    pos.Row = (int)((point.y - Pad_Bottom_Screen) / Sprite_Edge);
    return pos;
}


/*
 *  path array contains sequence of movement: L: Left, R: Right, U: Up, D: Down
 *  iterate through the input path string to create a movement of a sprite
 */
-(void) moveBot: (NSString*) path{
    
    SKNode* myBot = [self childNodeWithName:@"bot"];
    if (myBot == nil) {
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
    [myBot runAction:moveSequence];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        MatrixPosStruct pos = [self getMatrixPos:location];
        
        NSString* path = [gameLogic getShortestPath:pos];
        [self moveBot:path];

        //handle 1 touch
        break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

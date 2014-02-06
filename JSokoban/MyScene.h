//
//  MyScene.h
//  JSokoban
//

//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLogic.h"

@interface MyScene : SKScene {
    
}

//methods
-(void) setGameLogic: (GameLogic*) gameLogic;

-(void) createMaze;

@end




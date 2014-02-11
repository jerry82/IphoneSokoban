//
//  MyScene.h
//  JSokoban
//

//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLogic.h"

@class ViewController;

@interface MyScene : SKScene {
    
}

@property (assign) int CurrentLevel;

@property (nonatomic, weak) ViewController *viewController;

-(void) createMaze: (NSMutableArray*) newMaze;

@end




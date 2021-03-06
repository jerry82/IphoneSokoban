//
//  MyScene.h
//  JSokoban
//

//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLogic.h"
#import "LevelDetailItem.h"

@class ViewController;

@interface GameScene : SKScene {
    
}

@property LevelDetailItem* LevelDetail;

@property (assign) int AlreadyCompleted;

@property (nonatomic, weak) ViewController *viewController;

- (void) setGameLogic: (GameLogic*) theGameLogic;

-(void) createMaze: (NSMutableArray*) newMaze;

@end




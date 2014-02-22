//
//  ViewController.m
//  JSokoban
//
//  Created by Jerry on 27/1/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"
#import "GameLogic.h"
#import "EpisodeScene.h"
#import "FirstScene.h"

@implementation ViewController {

}

@synthesize sharedGameLogic;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedGameLogic = [GameLogic sharedGameLogic];
    [self createFirstScene];
}

- (void) createFirstScene {
    SKView* skView = (SKView*) self.view;
    FirstScene* scene = [FirstScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.MainViewController = self;
    
    [skView presentScene:scene];
}

- (void) showWinGameScene {
    SKView* skView = (SKView*) self.view;
    FirstScene* scene = [[FirstScene alloc] initWinGameScence:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.MainViewController = self;
    
    [skView presentScene:scene];
}


- (void) createEpisodeScene {
    
    SKView* skView = (SKView*) self.view;
    
    // Create and configure the scene.
    EpisodeScene* scene = [EpisodeScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.MainViewController = self;
    
    [skView presentScene:scene];
}

- (void) createNewScene: (LevelDetailItem*) curLevel chooseNext: (BOOL) next alreadycompleted:(int)level {
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    LevelDetailItem* nextLevel;
    if (next) {
        nextLevel = [sharedGameLogic getNextLevelDetailItem:curLevel];
    }
    else {
        nextLevel = [sharedGameLogic getPrevLevelDetailItem:curLevel];
    }
    
    //pass the maze to skscene
    
    if (nextLevel == nil) {
        NSLog(@"no more level");
        return;
    }
    else if ([nextLevel.Content length] == 0) {
        NSLog(@"no more level");
        return;
    }
    
    // Create and configure the scene.
    GameScene * scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    scene.viewController = self;
    //keep game logic instance in ViewController
    [scene setGameLogic:sharedGameLogic];
    
    scene.LevelDetail = nextLevel;
    scene.AlreadyCompleted = level;
    
    //printf("current level:%d, completed: %d", nextLevel.LevelNum, level);

    [scene createMaze:nextLevel.MazeChars];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

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
    GameLogic* gameLogic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gameLogic = [GameLogic sharedGameLogic];
    
    [self createFirstScene];
    //[self createEpisodeScene];
    //[self createNewScene:Nil];
}

- (void) createFirstScene {
    SKView* skView = (SKView*) self.view;
    FirstScene* scene = [FirstScene sceneWithSize:skView.bounds.size];
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

- (void) createNewScene: (LevelDetailItem*) curLevel chooseNext: (BOOL) next {
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    LevelDetailItem* nextLevel;
    if (next) {
        nextLevel = [gameLogic getNextLevelDetailItem:curLevel];
    }
    else {
        nextLevel = [gameLogic getPrevLevelDetailItem:curLevel];
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
    scene.LevelDetail = nextLevel;
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.viewController = self;


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

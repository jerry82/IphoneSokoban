//
//  ViewController.m
//  JSokoban
//
//  Created by Jerry on 27/1/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "GameLogic.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createNewScene:2];
}

- (void) createNewScene: (int)level {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    GameLogic* sharedGameLogic = [GameLogic sharedGameLogic];
    NSMutableArray* mazeChars = [sharedGameLogic getMaze:level];
    //pass the maze to skscene
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.viewController = self;
    scene.CurrentLevel = level;

    
    [scene createMaze:mazeChars];
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

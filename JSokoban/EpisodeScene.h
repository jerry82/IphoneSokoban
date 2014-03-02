//
//  EpisodeScene.h
//  JSokoban
//
//  Created by Jerry on 14/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"

static NSString* const LevelNodeName = @"moveable-level";

@interface EpisodeScene : SKScene

@property (weak) ViewController* MainViewController;

@end

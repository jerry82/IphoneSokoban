//
//  ViewController.h
//  JSokoban
//

//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "LevelDetailItem.h"

@interface ViewController : UIViewController

- (void) createNewScene: (LevelDetailItem*) curLevel;

- (void) createEpisodeScene;

@end

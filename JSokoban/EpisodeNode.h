//
//  EpisodeNode.h
//  JSokoban
//
//  Created by Jerry on 2/3/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EpisodeItem.h"

@interface EpisodeNode : SKNode

- (id) initWithPos: (CGSize) screenSize
               itemHeight: (float)itemH nth: (int) nth withItem: (EpisodeItem*) item;

@end

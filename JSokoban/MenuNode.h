//
//  MenuNode.h
//  JSokoban
//
//  Created by Jerry on 13/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MenuNode : SKNode

- (id) initMenuWithPos: (CGPoint) pos andSize: (CGSize) screenSize;

- (id) initDialogWithPos: (CGPoint) pos andSize:(CGSize) screenSize completeEpisode: (BOOL) completed;

- (id) initInstructionDialogWithPos: (CGPoint) pos andSize: (CGSize) screenSize;



@end

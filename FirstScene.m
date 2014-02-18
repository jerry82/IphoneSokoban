//
//  FirstScene.m
//  JSokoban
//
//  Created by Jerry on 15/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameLogic.h"
#import "FirstScene.h"

@implementation FirstScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self createGUI];
    }
    
    return self;
}

- (void) createGUI {
    //background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:SPLASHSCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    background.name = @"bg";
    [self addChild:background];
    
    //SKAction* fadeIn = [SKAction fadeInWithDuration:2];
    SKAction* wait = [SKAction waitForDuration:3];
    //SKAction* seq = [SKAction sequence:@[fadeIn, wait]];
    [background runAction:wait completion:^{
        [self.MainViewController createEpisodeScene];
    }];
}


//handle touch
/*
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    NSLog(@"%@", node.name);
    
    if (node.name != nil) {
        [self.MainViewController createEpisodeScene];
    }
}*/


@end

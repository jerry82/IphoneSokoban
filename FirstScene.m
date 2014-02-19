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

-(id) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self createGUIFirstScreen];
    }
    
    return self;
}

-(id) initWinGameScence: (CGSize) size {
    if (self = [super initWithSize:size]) {
        [self createWinGameScreen];
    }
    
    return self;
}

- (void) createWinGameScreen {
    //background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:WINGAME_SCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    background.name = WINGAME_SCREEN_NAME;
    [self addChild:background];
}

- (void) createGUIFirstScreen {
    //background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:SPLASHSCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    background.name = SPLASHSCREEN_NAME;
    [self addChild:background];
    
    SKLabelNode* loadingText = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    loadingText.fontSize = 15;
    loadingText.fontColor = [UIColor whiteColor];
    loadingText.text = @"loading...";
    loadingText.position = CGPointMake(self.size.width / 2, 20);
    [self addChild:loadingText];
    
    //SKAction* fadeIn = [SKAction fadeInWithDuration:2];
    SKAction* wait = [SKAction waitForDuration:4];
    //SKAction* seq = [SKAction sequence:@[fadeIn, wait]];
    [background runAction:wait completion:^{
        [self.MainViewController createEpisodeScene];
    }];
}


//handle touch for wingame screen
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    NSLog(@"%@", node.name);
    
    if (node.name != nil) {
        if ([node.name isEqual:WINGAME_SCREEN_NAME])
            [self.MainViewController createEpisodeScene];
    }
}


@end

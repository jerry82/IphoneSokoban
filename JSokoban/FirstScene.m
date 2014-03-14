//
//  FirstScene.m
//  JSokoban
//
//  Created by Jerry on 15/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameLogic.h"
#import "FirstScene.h"
#import "GameCenter.h"

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
    
    SKLabelNode* rateText = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    rateText.fontSize = 20;
    rateText.fontColor = [UIColor whiteColor];
    rateText.text = @"    [Rate me]    ";
    rateText.name = RATEME_NAME;
    rateText.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 70);
    [self addChild:rateText];
    
    SKLabelNode* playText = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    playText.fontSize = 30;
    playText.fontColor = [UIColor whiteColor];
    playText.text = @"ENTER GAME";
    playText.name = PLAYNAME;
    playText.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:playText];

    
    /*
    SKLabelNode* loadingText = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    loadingText.fontSize = 15;
    loadingText.fontColor = [UIColor whiteColor];
    loadingText.text = @"loading...";
    loadingText.position = CGPointMake(self.size.width / 2, 20);
    [self addChild:loadingText];
    
    
    SKAction* wait = [SKAction waitForDuration:4];
    [background runAction:wait completion:^{
        [self.MainViewController createEpisodeScene];
    }];*/
}


//handle touch for wingame screen
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    NSLog(@"%@", node.name);
    
    if (node.name != nil) {
        if ([node.name isEqual:PLAYNAME]) {
            SKAction* wait = [SKAction scaleBy:1.5 duration:0.1];
            [node runAction:wait completion:^{
                
                //submit score here
                [[GameCenter sharedInstance] submitScore];
                
                [self.MainViewController createEpisodeScene];
            }];
        }
        else if ([node.name isEqual:RATEME_NAME]) {
            SKAction* wait = [SKAction scaleBy:1.5 duration:0.1];
            [node runAction:wait completion:^{
                [[GameLogic sharedGameLogic] rateMyApplication];
                NSLog(@"rate");
            }];
            
        }
        
        else if ([node.name isEqual:WINGAME_SCREEN_NAME]) {
            
        }
    }
}


@end

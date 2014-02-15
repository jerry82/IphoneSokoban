//
//  EpisodeScene.m
//  JSokoban
//
//  Created by Jerry on 14/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "EpisodeScene.h"
#import "GameLogic.h"
#import "EpisodeItem.h"

@implementation EpisodeScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
                
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        //self.backgroundColor = [SKColor colorWithRed:(float)242/255 green:(float)236/255 blue:(float)212/255 alpha:1];
        //self.backgroundColor = [SKColor colorWithRed:(float)185/255 green:(float)233/255 blue:(float)255/255 alpha:1];
        
        
        [self createGUI];
    }
    
    return self;
}


//divide height to 6 equal size
-(void) createGUI {
    
    float dh = self.size.height / 7;
    
    //background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:EPISODE_SCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    [self addChild:background];
    
    SKLabelNode* title = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    title.fontSize = 40;
    title.text = @"Select Adventure";
    title.position = CGPointMake(self.size.width / 2, self.size.height - dh);
    [self addChild:title];
    
    
    NSMutableArray* allEpisodes = [[GameLogic sharedGameLogic] getAllEpisodes];
    if (allEpisodes.count > 0) {
        
        for (int i = 0; i < allEpisodes.count; i++) {
            EpisodeItem* item = [allEpisodes objectAtIndex:i];
            
            //create episode
            /*
            SKSpriteNode* ep = [SKSpriteNode spriteNodeWithImageNamed:EPISODE_IMG];
            ep.position = CGPointMake(10 + ep.size.width/2, self.size.height / 2);
            [self addChild:ep];
            */
            
            SKSpriteNode* bar = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.2] size:CGSizeMake(self.size.width, dh)];
            bar.position = CGPointMake(self.size.width / 2, self.size.height - (i + 2) * dh);
            bar.hidden = YES;
            //
            bar.name = [NSString stringWithFormat:@"%d_%d", item.PackId, item.LevelCompleted];
            bar.zPosition = 10;
            [self addChild:bar];
            
            UIColor* white = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            
            SKLabelNode* text = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            text.fontSize = 40;
            text.fontColor = [UIColor colorWithRed:(float)213/255 green:(float)198/255 blue:(float)105/255 alpha:1];
            text.text = [NSString stringWithFormat:@"%d", item.PackId];
            text.position = CGPointMake(20, self.size.height - (i + 2) * dh);
            [self addChild:text];
            
            SKLabelNode* completed = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            completed.fontSize = 20;
            completed.fontColor = white;
            completed.text = [NSString stringWithFormat: @"Completed: %d/%d", item.LevelCompleted, item.NumOfLevels];
            completed.position = CGPointMake(text.position.x + 120, text.position.y);
            [self addChild:completed];
            
            SKLabelNode* star = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            star.fontSize = 15;
            star.fontColor = white;
            star.text = @"(* * *)";
            star.position = CGPointMake(text.position.x + 70, text.position.y + 20);
            [self addChild:star];
            
        }
    }
}

//handle touch
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    NSLog(@"%@", node.name);
    
    if (node.name != nil) {
        node.hidden = NO;
        SKAction* action = [SKAction waitForDuration:0.2];
        [node runAction:action completion:^{
            LevelDetailItem* item = [[LevelDetailItem alloc] init];
            NSArray* tokens = [node.name componentsSeparatedByString:@"_"];
            
            item.PackId = [[tokens objectAtIndex:0] intValue];
            item.LevelNum = [[tokens objectAtIndex:1] intValue];
            
            [self.MainViewController createNewScene:item];
        }];
    }
}

@end

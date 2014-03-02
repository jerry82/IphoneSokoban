//
//  EpisodeNode.m
//  JSokoban
//
//  Created by Jerry on 2/3/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "EpisodeNode.h"
#import "GameLogic.h"

@implementation EpisodeNode

- (id) initWithPos:(CGSize)screenSize itemHeight: (float) itemH nth: (int) nth withItem: (EpisodeItem*) item {
    
    if (self = [super init]) {
        
        SKSpriteNode* bar = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] size:CGSizeMake(screenSize.width, itemH)];
        bar.position = CGPointMake(bar.size.width / 2, screenSize.height - (nth + 2) * itemH + 10);

        bar.hidden = YES;
        //
        bar.name = [NSString stringWithFormat:@"%d_%d_%d_%d", item.PackId, item.LevelCompleted, item.NumOfLevels, item.Lock];
        bar.zPosition = 10;
        [self addChild:bar];
        
        UIColor* white = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        SKLabelNode* epNum = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
        epNum.fontSize = 40;
        epNum.fontColor = [UIColor colorWithRed:(float)213/255 green:(float)198/255 blue:(float)105/255 alpha:1];
        epNum.text = [NSString stringWithFormat:@"%d", item.PackId];
        epNum.position = CGPointMake(40, bar.position.y - 20);
        [self addChild:epNum];
        
        SKLabelNode* completed = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
        completed.fontSize = 20;
        completed.fontColor = white;
        completed.text = [NSString stringWithFormat: @"(%d/%d)", item.LevelCompleted, item.NumOfLevels];
        completed.position = CGPointMake(epNum.position.x + 140, epNum.position.y + 10);
        
        [self addChild:completed];
        
        SKLabelNode* text = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
        text.fontSize = 15;
        text.fontColor = white;
        text.text = @"Completed:";
        text.position = CGPointMake(epNum.position.x + 70, epNum.position.y + 10);
        [self addChild:text];
        
        
        if (item.Lock == 1) {
            SKSpriteNode* lock = [SKSpriteNode spriteNodeWithImageNamed:LOCK_IMG];
            lock.position = CGPointMake(screenSize.width - lock.size.width, bar.position.y);
            [self addChild:lock];
        }
    }

    return self;
}

@end

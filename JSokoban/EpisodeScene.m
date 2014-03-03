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
#import "EpisodeNode.h"

@implementation EpisodeScene {
    float _itemHeight;
    NSMutableArray* levelSprites;
    NSMutableArray* yInitialPositions;
    float _scrollScreenDuration;
    CGPoint _titleFloorMargin;
    CGPoint _titleCeilMargin;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
                
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        //self.backgroundColor = [SKColor colorWithRed:(float)242/255 green:(float)236/255 blue:(float)212/255 alpha:1];
        //self.backgroundColor = [SKColor colorWithRed:(float)185/255 green:(float)233/255 blue:(float)255/255 alpha:1];
        
        _itemHeight = self.size.height / 7;
        levelSprites = [[NSMutableArray alloc] init];
        _scrollScreenDuration = 0.3;

        
        [self createGUI];
    }
    
    return self;
}

//divide height to 6 equal size
-(void) createGUI {

    //background
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:EPISODE_SCREEN_IMG];
    background.position = CGPointMake(background.size.width / 2, background.size.height / 2);
    [self addChild:background];
    
    SKLabelNode* title = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
    title.fontSize = 40;
    title.text = @"Select Adventure";
    title.position = CGPointMake(self.size.width / 2, self.size.height - _itemHeight);
    title.name = @"title";
    [self addChild:title];
    
    [self createEpisodes];
    
    _titleFloorMargin = CGPointMake(self.size.width / 2, self.size.height - _itemHeight);
    _titleCeilMargin = CGPointMake(self.size.width / 2, _itemHeight * (1 + levelSprites.count));
}

- (void) createEpisodes {

    NSMutableArray* allEpisodes = [[GameLogic sharedGameLogic] getAllEpisodes];
    
    if (allEpisodes.count > 0) {
        for (int i = 0; i < allEpisodes.count; i++) {
            EpisodeItem* item = [allEpisodes objectAtIndex:i];
            EpisodeNode* epNode = [[EpisodeNode alloc] initWithPos:self.size itemHeight:_itemHeight nth:i withItem:item];
            [self addChild:epNode];
            epNode.name = LevelNodeName;
            [levelSprites addObject:epNode];
            [yInitialPositions addObject:[NSNumber numberWithFloat:epNode.position.y]];
        }
    }
}

- (void) didMoveToView:(SKView *)view {
    
    UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [[self view] addGestureRecognizer:panGes];
    
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [[self view] addGestureRecognizer:tapGes];
}

- (void) handlePan: (UIPanGestureRecognizer*) panGes {
    
    if (panGes.state == UIGestureRecognizerStateEnded) {

        CGPoint velocity = [panGes velocityInView:panGes.view];
        //CGPoint translation = [panGes translationInView:panGes.view];
        CGPoint translation = CGPointMake(velocity.x * 0.2, velocity.y * 0.2);
        
        int direction = (velocity.y > 0) ? -1 : 1;
        
        SKNode* titleNode = [self getTitleNode];
        
        float delta;
        
        if (titleNode.position.y - translation.y < _titleFloorMargin.y) {
            delta = _titleFloorMargin.y - titleNode.position.y - 10;
            [self scrollScreen:direction moveByY:delta];
        }
        else if (titleNode.position.y - translation.y > _titleCeilMargin.y) {
            delta = _titleCeilMargin.y - titleNode.position.y + 10;
            [self scrollScreen:direction moveByY:delta];
        }
        else {
            //delta = direction * 3 * _itemHeight;
            delta = -1 * translation.y;
            [self scrollScreen:direction moveByY:delta];
        }
    }
}

- (void) scrollScreen: (int) direction moveByY: (float)y {
    SKAction* move = [SKAction moveByX:0 y: y duration:_scrollScreenDuration];
    [move setTimingMode:SKActionTimingEaseOut];
    
    for (int i = 0; i < levelSprites.count; i++) {
        SKNode* node = (SKNode*) [levelSprites objectAtIndex:i];
        [node runAction:move completion:^{[self moveBack];}];
    }
    SKNode* titleNode = [self getTitleNode];
    [titleNode runAction:move completion:^{[self moveBack];}];
}

- (void) moveBack {
    CGPoint fix = CGPointMake(self.size.width / 2, self.size.height - _itemHeight);
    SKNode* titleNode = [self getTitleNode];
    
    float moveBackDuration = 0.05;
    
    if (titleNode.position.y < fix.y) {
        SKAction* moveBack = [SKAction moveToY:fix.y duration:moveBackDuration];
        [titleNode runAction:moveBack];

        for (int i = 0; i < levelSprites.count; i++) {
            float y = [[yInitialPositions objectAtIndex:i] floatValue];
            
            SKNode* node = (SKNode*)[levelSprites objectAtIndex:i];
            moveBack = [SKAction moveToY:y duration:moveBackDuration];
            [node runAction:moveBack];
        }
    }
}

- (SKNode*) getTitleNode {
    SKNode* node = [self childNodeWithName:@"title"];
    return node;
}

- (void) handleTap: (UITapGestureRecognizer*) tapGes {
    
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        printf("tap\n");
        CGPoint location = [tapGes locationInView:tapGes.view];
        
        //this is important
        location = [self convertPointFromView:location];
        
        SKNode* node = [self nodeAtPoint:location];
        
        NSLog(@"%@", node.name);
        if (node.name != nil) {
            //check bar press
            NSArray* tokens = [node.name componentsSeparatedByString:@"_"];
            
            //MARK: take out to access all locked levels
            //return if lock
            /*
             int lock = [[tokens objectAtIndex:3] intValue];
             if (lock == 1)
             return;
             */
            
            LevelDetailItem* item = [[LevelDetailItem alloc] init];
            item.PackId = [[tokens objectAtIndex:0] intValue];
            item.LevelNum = [[tokens objectAtIndex:1] intValue];
            
            int totalLevel = [[tokens objectAtIndex:2] intValue];
            
            int alreadycompleted = item.LevelNum;
            //if completed all level in episode
            if (totalLevel == item.LevelNum) {
                item.LevelNum -= 1;
                printf("level num: %d", item.LevelNum);
            }
            
            node.hidden = NO;
            SKAction* action = [SKAction waitForDuration:0.2];
            [node runAction:action completion:^{
                //chooseNext or Previous
                [self.MainViewController createNewScene:item chooseNext:YES alreadycompleted:alreadycompleted];
            }];
        }
        
    }
}

- (void) clearCurrentLevelSprites {
    for (int i = 0; i < levelSprites.count; i++) {
        SKSpriteNode* tmp = [levelSprites objectAtIndex:i];
        [tmp removeAllChildren];
        [tmp removeFromParent];
    }
    [levelSprites removeAllObjects];
}

@end

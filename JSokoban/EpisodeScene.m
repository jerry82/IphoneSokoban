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

@implementation EpisodeScene {
    int PAGESIZE;
    float ItemHeight;
    int curPageNo;
    int maxPageNo;
    NSMutableArray* levelSprites;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
                
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        //self.backgroundColor = [SKColor colorWithRed:(float)242/255 green:(float)236/255 blue:(float)212/255 alpha:1];
        //self.backgroundColor = [SKColor colorWithRed:(float)185/255 green:(float)233/255 blue:(float)255/255 alpha:1];
        
        PAGESIZE = 5;
        ItemHeight = self.size.height / 7;
        curPageNo = 0;
        levelSprites = [[NSMutableArray alloc] init];
        
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
    title.position = CGPointMake(self.size.width / 2, self.size.height - ItemHeight);
    [self addChild:title];
    
    
    SKSpriteNode* downSprite = [SKSpriteNode spriteNodeWithImageNamed:DOWN_IMG];
    downSprite.name = DOWN_NAME;
    downSprite.position = CGPointMake(self.size.width / 2 + downSprite.size.width, downSprite.size.height / 2);
    
    SKSpriteNode* upSprite = [SKSpriteNode spriteNodeWithImageNamed:UP_IMG];
    upSprite.name = UP_NAME;
    upSprite.position = CGPointMake(self.size.width / 2 - upSprite.size.width, upSprite.size.height / 2);
    
    [self addChild:downSprite];
    [self addChild:upSprite];
    
    
    curPageNo = 0;
    [self createEpisodes: curPageNo];
   
}

- (void) createEpisodes: (int) pageNo {

    NSMutableArray* allEpisodes = [[GameLogic sharedGameLogic] getAllEpisodes];
    
    maxPageNo = (int)(allEpisodes.count / PAGESIZE);
    if (allEpisodes.count % PAGESIZE == 0)
        maxPageNo -= 1;
    //NSLog(@"maxpage: %d", maxPageNo);
    
    if (allEpisodes.count > 0) {
        
        int j = pageNo * PAGESIZE;
        while (j < pageNo * PAGESIZE + PAGESIZE) {
            if (j >= allEpisodes.count)
                break;
            
            EpisodeItem* item = [allEpisodes objectAtIndex:j];
            int i = j % PAGESIZE;
            
            SKSpriteNode* bar = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.2] size:CGSizeMake(self.size.width, ItemHeight)];
            bar.position = CGPointMake(self.size.width / 2, self.size.height - (i + 2) * ItemHeight);
            bar.hidden = YES;
            //
            bar.name = [NSString stringWithFormat:@"%d_%d_%d", item.PackId, item.LevelCompleted, item.NumOfLevels];
            bar.zPosition = 10;
            [self addChild:bar];
            
            UIColor* white = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            
            SKLabelNode* epNum = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            epNum.fontSize = 40;
            epNum.fontColor = [UIColor colorWithRed:(float)213/255 green:(float)198/255 blue:(float)105/255 alpha:1];
            epNum.text = [NSString stringWithFormat:@"%d", item.PackId];
            epNum.position = CGPointMake(40, self.size.height - (i + 2) * ItemHeight - 20);
            [self addChild:epNum];
            
            SKLabelNode* completed = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            completed.fontSize = 20;
            completed.fontColor = white;
            completed.text = [NSString stringWithFormat: @"(%d/%d)", item.LevelCompleted, item.NumOfLevels];
            completed.position = CGPointMake(epNum.position.x + 140, epNum.position.y + 10);
            [self addChild:completed];
            
            SKLabelNode* star = [[SKLabelNode alloc] initWithFontNamed:APP_FONT_NAME];
            star.fontSize = 15;
            star.fontColor = white;
            star.text = @"Completed:";
            star.position = CGPointMake(epNum.position.x + 70, epNum.position.y + 10);
            [self addChild:star];
            
            
            if (item.Lock == 1) {
                SKSpriteNode* lock = [SKSpriteNode spriteNodeWithImageNamed:LOCK_IMG];
                lock.position = CGPointMake(self.size.width - lock.size.width, self.size.height - (i + 2) * ItemHeight);
                [self addChild:lock];
                [levelSprites addObject:lock];
            }
            
            [levelSprites addObject:bar];
            [levelSprites addObject:epNum];
            [levelSprites addObject:completed];
            [levelSprites addObject:star];
            
            
            j += 1;
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
        if ([node.name isEqual:DOWN_NAME]) {
            //clear old level sprite
            [self clearCurrentLevelSprites];
            
            curPageNo += 1;
            if (curPageNo > maxPageNo)
                curPageNo = maxPageNo;
            
            [self createEpisodes:curPageNo];
        }
        else if ([node.name isEqual:UP_NAME]) {
            [self clearCurrentLevelSprites];
            curPageNo -= 1;
            if (curPageNo < 0) {
                curPageNo = 0;
            }
            [self createEpisodes:curPageNo];
        }
        //check bar press
        else {
            node.hidden = NO;
            SKAction* action = [SKAction waitForDuration:0.2];
            [node runAction:action completion:^{
                LevelDetailItem* item = [[LevelDetailItem alloc] init];
                NSArray* tokens = [node.name componentsSeparatedByString:@"_"];
                
                item.PackId = [[tokens objectAtIndex:0] intValue];
                item.LevelNum = [[tokens objectAtIndex:1] intValue];
            
                int totalLevel = [[tokens objectAtIndex:2] intValue];
                int alreadycompleted = item.LevelNum;
                
                //if completed all level in episode
                if (totalLevel == item.LevelNum) {
                    item.LevelNum -= 1;
                    printf("level num: %d", item.LevelNum);
                }
                
                //chooseNext or Previous
                [self.MainViewController createNewScene:item chooseNext:YES alreadycompleted:alreadycompleted];
            }];
        }
    }
}

- (void) clearCurrentLevelSprites {
    for (int i = 0; i < levelSprites.count; i++) {
        SKSpriteNode* tmp = [levelSprites objectAtIndex:i];
        [tmp removeFromParent];
    }
    [levelSprites removeAllObjects];
}

@end

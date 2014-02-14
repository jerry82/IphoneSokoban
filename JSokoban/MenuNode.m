//
//  MenuNode.m
//  JSokoban
//
//  Created by Jerry on 13/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "MenuNode.h"
#import "GameLogic.h"

@implementation MenuNode

- (id) initMenuWithPos: (CGPoint) pos andSize:(CGSize) screenSize {
    if (self = [super init]) {
        [self createBackground:screenSize];
        [self createMenu: pos];
    }
    return self;
}

- (id) initDialogWithPos: (CGPoint) pos andSize:(CGSize) screenSize {
    if (self = [super init]) {
        [self createBackground:screenSize];
        [self createDialog: pos];
        
    }
    return self;
}

- (void) createBackground: (CGSize) screenSize {
    SKSpriteNode* bg = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] size:screenSize];
    bg.name = MENUBG_NAME;
    bg.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    bg.zPosition = self.zPosition + 1;
    
    [self addChild:bg];
}

- (void) createDialog: (CGPoint) pos {
    SKSpriteNode* dialogSprite = [SKSpriteNode spriteNodeWithImageNamed: WINDIALOG_IMG];
    dialogSprite.name = WINDIALOG_NAME;
    dialogSprite.position = pos;
    dialogSprite.zPosition = self.zPosition + 2;
    [self addChild:dialogSprite];
    
    SKSpriteNode* menubtnSprite = [SKSpriteNode spriteNodeWithImageNamed: MENUBTN_IMG];
    menubtnSprite.name = MENUBTN_NAME;
    menubtnSprite.position = CGPointMake(pos.x - 100, pos.y);
    menubtnSprite.zPosition = self.zPosition + 3;
    [self addChild:menubtnSprite];
    
    
    SKSpriteNode* restartbtnSprite = [SKSpriteNode spriteNodeWithImageNamed: RESTARTBTN_IMG];
    restartbtnSprite.name = RESTARTBTN_NAME;
    restartbtnSprite.position = CGPointMake(pos.x, pos.y);
    restartbtnSprite.zPosition = self.zPosition + 3;
    [self addChild:restartbtnSprite];
    
    SKSpriteNode* nextbtnSprite = [SKSpriteNode spriteNodeWithImageNamed: NEXTBTN_IMG];
    nextbtnSprite.name = NEXTBTN_NAME;
    nextbtnSprite.position = CGPointMake(pos.x + 100, pos.y);
    nextbtnSprite.zPosition = self.zPosition + 3;
    [self addChild:nextbtnSprite];
    
}

- (void) createMenu: (CGPoint) pos {
    SKSpriteNode* menuSprite = [SKSpriteNode spriteNodeWithImageNamed: MENUBAR_IMG];
    menuSprite.name = MENUBAR_NAME;
    menuSprite.position = pos;
    menuSprite.zPosition = self.zPosition + 2;
    [self addChild:menuSprite];
    
    SKSpriteNode* menubtnSprite = [SKSpriteNode spriteNodeWithImageNamed: MENUBTN_IMG];
    menubtnSprite.name = MENUBTN_NAME;
    menubtnSprite.position = CGPointMake(pos.x - 100, pos.y);
    menubtnSprite.zPosition = self.zPosition + 3;
    [self addChild:menubtnSprite];
    
    SKSpriteNode* restartbtnSprite = [SKSpriteNode spriteNodeWithImageNamed: RESTARTBTN_IMG];
    restartbtnSprite.name = RESTARTBTN_NAME;
    restartbtnSprite.position = CGPointMake(pos.x, pos.y);
    restartbtnSprite.zPosition = self.zPosition + 3;
    [self addChild:restartbtnSprite];
    
    SKSpriteNode* soundonbtnSprite = [SKSpriteNode spriteNodeWithImageNamed: SOUNDONBTN_IMG];
    soundonbtnSprite.name = SOUNDONBTN_NAME;
    soundonbtnSprite.position = CGPointMake(pos.x + 100, pos.y);
    soundonbtnSprite.zPosition = self.zPosition + 3;
    [self addChild:soundonbtnSprite];
}


@end

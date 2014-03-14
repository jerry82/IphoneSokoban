//
//  GameCenter.h
//  JSokoban
//
//  Created by Jerry on 13/3/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "DataAccess.h"

@interface GameCenter : NSObject <GKGameCenterControllerDelegate> {
    BOOL _gameCenterAvailable;
    BOOL _userAuthenticated;
}

@property (assign, readonly) BOOL GameCenterAvailable;

+ (GameCenter*) sharedInstance;

-(void) authenticateLocalUser;

-(void) submitScore;

-(UIViewController*) getRootViewController;

-(void) showLeaderBoard;

@end

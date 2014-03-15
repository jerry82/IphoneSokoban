//
//  GameCenter.m
//  JSokoban
//
//  Created by Jerry on 13/3/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "GameCenter.h"
#import "AppDelegate.h"
#import "GameLogic.h"

@implementation GameCenter

@synthesize GameCenterAvailable=_gameCenterAvailable;

static GameCenter *sharedHelper = nil;

+ (GameCenter*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GameCenter alloc] init];
    }
    return sharedHelper;
}

- (BOOL) isGameCenterAvailable {
    //check GKLocalPlayer api available
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check device run iOS4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString* currSysVer = [[UIDevice currentDevice] systemName];
    BOOL osVersionSupport = ([currSysVer compare:reqSysVer
                                        options:NSNumericSearch] != NSOrderedAscending);
    
    return gcClass && osVersionSupport;
}

- (id) init {
    if (self = [super init]) {
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (_gameCenterAvailable) {
            NSLog(@"game center is available");
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    
    return self;
}

- (void) authenticationChanged {

    if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        _userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        _userAuthenticated = FALSE;
    }
}

- (void)authenticateLocalUser {
    
    if (!_gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    @try {
        if ([GKLocalPlayer localPlayer].authenticated == NO) {
            
            GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
            
            localPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error) {
                if (localPlayer.authenticated) {
                    //already authenticated
                }
                
                else if(viewController) {
                    NSLog(@"Need to log in");
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    [appDelegate.window.rootViewController presentViewController:viewController animated:YES completion:nil];
                    _userAuthenticated = true;
                }
                
                else {
                    NSLog(@"error login");
                    _userAuthenticated = false;
                }
            };
            
        } else {
            NSLog(@"Already authenticated!");
        }
    }
    @catch (NSException* e) {
        NSLog(@"Error authenticate user: %@", e);
    }
}

- (void) submitScore {
    @try {
        
        NSLog(@"start submitting score...");
        int levels = [[DataAccess sharedInstance] getTotalScore];
        NSLog(@"total score: %d", levels);
        if (levels == -1) {
            NSLog(@"problem connect to db");
            return;
        }
        
        if (!_userAuthenticated) {
            NSLog(@"cannot submit score, user is not authenticated");
            return;
        }
            
        
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:LEADERBOARD];
        score.value = levels;
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error report score");
            }
            else {
                NSLog(@"succesful update score");
            }
        }];
    }
    @catch (NSException* e) {
        NSLog(@"error submitting score");
    }
    
}

//show leader board
- (void) showLeaderBoard {
    @try {
        GKLeaderboardViewController* leaderboardVC = [[GKLeaderboardViewController alloc] init];
        
        if (leaderboardVC != nil) {
            leaderboardVC.leaderboardDelegate = self;
            [[self getRootViewController] presentViewController:leaderboardVC animated:YES completion:nil];
        }
        else {
            NSLog(@"cannot show leaderboard");
        }
    }
    @catch (NSException* e) {
        NSLog(@"error show leader board: %@", e);
    }

}

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

- (void)gameCenterViewControllerDidFinish:(GKLeaderboardViewController *)gameCenterViewController {
	[gameCenterViewController dismissModalViewControllerAnimated:YES];
}


@end
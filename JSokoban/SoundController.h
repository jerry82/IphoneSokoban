//
//  SoundController.h
//  JSokoban
//
//  Created by Jerry on 16/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GameLogic.h"

@interface SoundController : NSObject {
    SystemSoundID _mySound;
    AVAudioPlayer* _bgMusicPlayer;
}

@property (assign) BOOL SoundEnabled;

- (id) initWithSound;
- (void) playRunSound;
- (void) playMoveSound;
- (void) playClapSound;
- (void) playBackgroundMusic;
- (void) stopBackgroundMusic;

@end

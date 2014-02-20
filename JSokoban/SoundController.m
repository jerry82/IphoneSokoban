//
//  SoundController.m
//  JSokoban
//
//  Created by Jerry on 16/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import "SoundController.h"

@implementation SoundController

- (id) initWithSound {
    if (self = [super init]) {
        
        NSError* error;
        NSString *path = [NSString stringWithFormat: @"%@/%@",
                          [[NSBundle mainBundle] resourcePath], INGAME_SOUND];
        NSURL *soundFileURL = [NSURL fileURLWithPath:path];
        _bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
        _bgMusicPlayer.numberOfLoops = -1; //infinite
        
        [_bgMusicPlayer prepareToPlay];
        //[_bgMusicPlayer play];
    }
    return self;
}

- (void) playRunSound {
    _mySound = [self createSoundID: RUN_SOUND];
    AudioServicesPlaySystemSound(_mySound);
}

//TODO: move sound need to change, too loud
- (void) playMoveSound {
    /*
    _mySound = [self createSoundID: MOVE_SOUND];
    AudioServicesPlaySystemSound(_mySound);
     */
}

- (void) playClapSound {
    _mySound = [self createSoundID: CLAP_SOUND];
    AudioServicesPlaySystemSound(_mySound);
}

- (void) playBackgroundMusic {
    [_bgMusicPlayer play];
}

- (void) stopBackgroundMusic {
    [_bgMusicPlayer stop];
}

//helper
- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@",
                      [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end

//
//  EpisodeItem.h
//  JSokoban
//
//  Created by Jerry on 14/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EpisodeItem : NSObject

@property int PackId;
@property NSString* Description;
@property int NumOfLevels;
@property int LevelCompleted;
@property NSString* Difficulty;
@property int Lock;

@end

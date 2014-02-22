//
//  LevelDetailItem.h
//  JSokoban
//
//  Created by Jerry on 14/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelDetailItem : NSObject

@property NSString* Content;
@property NSMutableArray* MazeChars;
@property (assign) int LevelNum;
@property (assign) int PackId;

@end

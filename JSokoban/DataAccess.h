//
//  DataAccess.h
//  JSokoban
//
//  Created by Jerry on 10/2/14.
//  Copyright (c) 2014 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccess : NSObject {
    
}

extern NSString* DatabasePath;

+ (id) sharedInstance;

- (NSString*) getLevel: (int) level;

@end

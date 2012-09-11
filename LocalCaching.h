//
//  LocalCaching.h
//  Meek Apps
//
//  Created by Mike Keller on 5/3/12.
//  Copyright (c) 2012 Meek Apps. All rights reserved.
//
//  Save and load generic Objective-C objects to Plist files.

#import <UIKit/UIKit.h>

@interface LocalCaching : NSObject {
    dispatch_queue_t diskQueue;
}

+ (LocalCaching*) mainCache;
- (void) saveObjectToFile:(id)theObject withFilename:(NSString*)filename;
- (id) loadObjectFromFile:(NSString*)filename;
- (void) deleteObject:(NSString*)filename;

@end

//
//  LocalCaching.h
//  Meek Apps
//
//  Created by Mike Keller on 5/3/12.
//  Copyright (c) 2012 Meek Apps. All rights reserved.
//
//  Save and load generic Objective-C objects to Plist files.

#import "LocalCaching.h"

static LocalCaching *instance;

@interface LocalCaching()
    - (NSString*) documentsDirectory;
@end

@implementation LocalCaching


- (id) init {
    self = [super init];
    if (self) {
        diskQueue = dispatch_queue_create("localcaching", NULL);
    }
    
    return self;
}


+ (LocalCaching*) mainCache {
	@synchronized(self) {
		if(!instance) {
			instance = [[LocalCaching alloc] init];
		}
	}
	
	return instance;
}


- (NSString*) documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDirectory = [paths objectAtIndex:0];
    
    return docsDirectory;
}


- (void) saveObjectToFile:(id)theObject withFilename:(NSString*)filename {
    if (theObject && filename) {
        
        dispatch_async(diskQueue, ^{
            NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:theObject];
            
            //Plist
            NSString *fullPath = [[self documentsDirectory] stringByAppendingFormat:@"/%@", filename];
            BOOL success = [objectData writeToFile:fullPath atomically:YES];
            if (success == NO) {
                NSLog(@"file write error: %@", [error description]);
            }
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished writing");
            });
        });
        
    } else {
        //NSLog(@"bad objects: %@", filename);
    }
}


- (id) loadObjectFromFile:(NSString *)filename {
    //Plist
    NSString *fullPath = [[self documentsDirectory] stringByAppendingFormat:@"/%@", filename];
    NSData *objectData = [[NSData alloc] initWithContentsOfFile:fullPath];
    id theObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
    
    return theObject;
}


- (void) deleteObject:(NSString*)filename {
    //Plist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [[self documentsDirectory] stringByAppendingFormat:@"/%@", filename];
    
    [fileManager removeItemAtPath:fullPath error:nil];
}

@end

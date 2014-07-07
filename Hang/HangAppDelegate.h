//
//  HangAppDelegate.h
//  Hang
//
//  Created by Joshua Ellington on 7/6/14.
//  Copyright (c) 2014 Joshua Ellington. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HangAppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSDictionary *apiResponse;
@property (strong, nonatomic) NSMutableArray *allResponses;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *sites;
@property (strong, nonatomic) NSString *apiKey;
@property (nonatomic, assign) NSInteger sitesCount;
@property (nonatomic, assign) NSInteger sitesDone;

@end

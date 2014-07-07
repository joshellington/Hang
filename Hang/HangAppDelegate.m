//
//  HangAppDelegate.m
//  Hang
//
//  Created by Joshua Ellington on 7/6/14.
//  Copyright (c) 2014 Joshua Ellington. All rights reserved.
//

#import "HangAppDelegate.h"

static NSString * const BaseURLString = @"http://api.tumblr.com/v2/blog/";

@implementation HangAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    _statusItem.title = @"";
    
    // The image that will be shown in the menu bar, a 16x16 black png works best
    _statusItem.image = [NSImage imageNamed:@"hang-icon"];
    
    // The highlighted image, use a white version of the normal image
    _statusItem.alternateImage = [NSImage imageNamed:@"hang-icon-alt"];
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;
    
    [self setupPath];
    [self setupMenu];
}

- (void)setupPath
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dir = [NSString stringWithFormat:@"%@",@"Hang"];
    self.path = [documentsDirectory stringByAppendingPathComponent:dir];
    NSError *error;
    
    if ([filemgr fileExistsAtPath:self.path ] == YES){
    }
    else
    {
        NSLog (@"File not found");
        [[NSFileManager defaultManager] createDirectoryAtPath:self.path withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

- (void)setupMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Refresh" action:@selector(refresh:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    _statusItem.menu = menu;
}

- (void)refresh:(id)sender
{
    [self getApiFeed];
}

- (void)getApiFeed
{
    NSString *apiUrl = [NSString stringWithFormat:@"%@unsplash.com/posts?api_key=fuiKNFp9vQFvjLNvx4sUwti4Yb5yGutBN4Xh10LXZhhRKjWlV4&notes_info=false", BaseURLString];
    NSURL *url = [NSURL URLWithString:apiUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Request success
        self.apiResponse = (NSDictionary *)responseObject;
        NSLog(@"Successful request.");
        
        [self saveDesktop];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request failed
        NSLog(@"Failed.");
    }];
    
    [operation start];
}

- (void)saveDesktop
{
    NSUInteger postCount = [self.apiResponse[@"response"][@"posts"] count];
    NSUInteger index = 0;
    NSLog(@"postCount: %lu", (unsigned long)postCount);
    
    for(id post in self.apiResponse[@"response"][@"posts"])
    {
        
        for(id photo in post[@"photos"])
        {
            NSArray *altSizes = photo[@"alt_sizes"];
            NSString *bigSizeUrl = [altSizes objectAtIndex:0][@"url"];
            NSLog(@"%@", bigSizeUrl);
            NSString *fileName = [bigSizeUrl lastPathComponent];
            NSURL  *url = [NSURL URLWithString:bigSizeUrl];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (urlData)
            {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", self.path, fileName];
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"%@", filePath);
            }
        }
        
        index++;
        NSLog(@"Index: %lu", (unsigned long)index);
        if (index == postCount) {
            [self setDesktop];
        }
    }
}

- (void)setDesktop
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.path
                                                        error:nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'jpg'"];
    NSArray *contentsArray = [contents filteredArrayUsingPredicate:predicate];
    NSUInteger randomIndex = arc4random() % [contentsArray count];
    NSString *randomImage = [contentsArray objectAtIndex:randomIndex];
    NSString *filePath = [self.path stringByAppendingPathComponent:randomImage];
    
    //    NSLog(@"%@", randomImage);

    // for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {
    // }
    
    NSWorkspace *sws = [NSWorkspace sharedWorkspace];
    NSURL *image = [NSURL fileURLWithPath:filePath];
    NSError *err = nil;
    for (NSScreen *screen in [NSScreen screens]) {
        NSDictionary *opt = [sws desktopImageOptionsForScreen:screen];
        [sws setDesktopImageURL:image forScreen:screen options:opt error:&err];
        
        if (err) {
            NSLog(@"%@",[err localizedDescription]);
        }else{
            NSNumber *scr = [[screen deviceDescription] objectForKey:@"NSScreenNumber"];
            NSLog(@"%@", scr);
            [self notify];
        }
    }
}

- (void)notify
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Refreshed"];
    [notification setInformativeText:@"Hung new wallpaper"];
    [notification setDeliveryDate:[NSDate dateWithTimeInterval:1 sinceDate:[NSDate date]]];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    [center scheduleNotification:notification];
}

- (void)terminate
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end

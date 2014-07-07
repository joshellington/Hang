//
//  HangAppDelegate.m
//  Hang
//
//  Created by Joshua Ellington on 7/6/14.
//  Copyright (c) 2014 Joshua Ellington. All rights reserved.
//

#import "HangAppDelegate.h"

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
    
    [self setupMenu];
}

- (void)setupMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Refresh" action:@selector(refresh:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit Hang" action:@selector(terminate:) keyEquivalent:@""];
    
    _statusItem.menu = menu;
}

- (void)refresh:(id)sender
{
    [self setDesktop];
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

- (void)setDesktop
{
    NSWorkspace *sws = [NSWorkspace sharedWorkspace];
    NSURL *image = [NSURL fileURLWithPath:@"/Library/Desktop Pictures/Zebras.jpg"];
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

- (void)saveWallpapers
{
    NSString *stringURL = @"https://s3.amazonaws.com/ooomf-com-files/wdXqHcTwSTmLuKOGz92L_Landscape.jpg";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"wdXqHcTwSTmLuKOGz92L_Landscape.jpg"];
        [urlData writeToFile:filePath atomically:YES];
    }
}

- (void)terminate
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end

//
//  GeneralPreferences.m
//  Hang
//
//  Created by Joshua Ellington on 7/6/14.
//  Copyright (c) 2014 Joshua Ellington. All rights reserved.
//

#import "GeneralPreferences.h"

@implementation GeneralPreferences

- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
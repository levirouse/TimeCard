//
//  AppDelegate.h
//  TimeCard
//
//  Created by Levi Rouse on 9/12/13.
//  Copyright (c) 2013 Levi Rouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong) IBOutlet NSButton *clockInOutButton;
@property (strong) IBOutlet NSTextField *commentField;
@property (strong) IBOutlet NSTextView *timeCardView;

- (IBAction) clockIn:  (id)sender;
- (IBAction) clockOut: (id)sender;

- (IBAction) openFile: (id)sender;
- (IBAction) saveFile: (id)sender;

- (void) appendToTimeCard: (NSString *) string;

- (NSString *) currentDateTimeString;

@end

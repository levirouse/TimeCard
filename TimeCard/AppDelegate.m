//
//  AppDelegate.m
//  TimeCard
//
//  Created by Levi on 9/12/13.
//  Copyright (c) 2015 Levi Rouse. All rights reserved.
//

#import "AppDelegate.h"
#import "NSTextView+DisableWordWrap.h"

@implementation AppDelegate {
    NSString *_clockTime;
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    _commentField.editable = NO;
    [_timeCardView disableWordWrap];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) app {
    return YES;
}

- (IBAction) clockIn: (id) sender {
    _clockTime = [self currentDateTimeString];
    [self appendToTimeCard: _clockTime];
    
    _commentField.editable = YES;
    [self.window makeFirstResponder: _commentField];
    
    _clockInOutButton.title = @"Clock Out";
    _clockInOutButton.action = @selector(clockOut:);
}

- (IBAction) clockOut: (id) sender {
    _clockTime = [self currentDateTimeString];
    
    NSString *comment = _commentField.stringValue;
    if (comment.length == 0) {
        comment = @"[No comment]";
    }
    
    NSString *timeCardString = [NSString stringWithFormat: @",%@,%@\n", _clockTime, comment];
    
    [self appendToTimeCard: timeCardString];
    
    _commentField.stringValue = @"";
    _commentField.editable = NO;
    
    _clockInOutButton.title = @"Clock In";
    _clockInOutButton.action = @selector(clockIn:);
    [self.window makeFirstResponder: _clockInOutButton];
}

- (IBAction) openFile: (id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    //[panel setMessage: @"Choose a file to open."];
    panel.allowedFileTypes = @[@"public.plain-text"];
    __weak NSOpenPanel *weakPanel = panel;
    
    [panel beginWithCompletionHandler: ^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray* urls = [weakPanel URLs];
            
            NSURL *url = urls[0];
            
            NSError *error;
            NSString *string = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error: &error];
            if (!string) {
                NSAlert *alert = [NSAlert alertWithError: error];
                [alert runModal];
                return;
            }
            _timeCardView.string = string;
        }
    }];
}

- (IBAction) saveFile: (id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes: @[@"public.plain-text"]];
    [panel setNameFieldStringValue: @"Invoice1.text"];
    __weak NSSavePanel *weakPanel = panel;
    
    [panel beginSheetModalForWindow: self.window completionHandler: ^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [weakPanel URL];
            NSString *string = _timeCardView.string;
            
            NSError *error;
            BOOL ok = [string writeToURL: url atomically: YES encoding: NSUTF8StringEncoding error: &error];
            if (!ok) {
                NSAlert *alert = [NSAlert alertWithError: error];
                [alert runModal];            }
        }
    }];
}

- (void) appendToTimeCard: (NSString *) string {
    NSRange end = NSMakeRange(_timeCardView.string.length, 0);
    
    [_timeCardView replaceCharactersInRange: end withString: string];
    
    end = NSMakeRange(_timeCardView.string.length, 0);
    [_timeCardView scrollRangeToVisible: end];
}

- (NSString *) currentDateTimeString {    
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    
    utcDateFormatter.locale = enUSPOSIXLocale;
    utcDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss";
    utcDateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    NSString *dateTimeString = [utcDateFormatter stringFromDate:[NSDate date]];
    
    return dateTimeString;
}
@end

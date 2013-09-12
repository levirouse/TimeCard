//
//  AppDelegate.m
//  TimeCard
//
//  Created by Levi on 9/12/13.
//  Copyright (c) 2013 Levi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate  {
    NSString *_clockedInAt;
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification{
    [_commentField setEditable: NO];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) app{
    return YES;
}

- (IBAction) clockIn: (id)sender {
    _clockedInAt = [self currentDateTimeString];
    [self appendToTimeCard: _clockedInAt];
    
    [_commentField setEditable: YES];
    [[_commentField window] makeFirstResponder: _commentField];
    
    [_clockInOutButton setTitle: @"Clock Out"];
    [_clockInOutButton setAction: @selector(clockOut:)];
}

- (IBAction) clockOut: (id)sender {
    _clockedInAt = [self currentDateTimeString];
    
    NSString *comment = _commentField.stringValue;
    if (comment.length == 0) {
        comment = @"[No comment]";
    }
    
    NSString *timeCardString = [[NSString alloc] initWithFormat: @", %@, %@\n", _clockedInAt, comment];
    
    [self appendToTimeCard: timeCardString];
    
    [_commentField setStringValue: @""];
    [_commentField setEditable: NO];
    
    [_clockInOutButton setTitle: @"Clock In"];
    [_clockInOutButton setAction: @selector(clockIn:)];
    [[_clockInOutButton window] makeFirstResponder: _clockInOutButton];
}

- (IBAction) openFile: (id)sender {
}

- (IBAction) saveFile: (id)sender {
}

- (void) appendToTimeCard: (NSString *) string {
    NSRange end = {self.timeCardView.string.length, 0};
    
    [self.timeCardView replaceCharactersInRange: end withString: string];
    
    end = NSMakeRange(self.timeCardView.string.length, 0);
    [self.timeCardView scrollRangeToVisible: end];
}

- (NSString *) currentDateTimeString
{    
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    
    [utcDateFormatter setLocale: enUSPOSIXLocale];
    [utcDateFormatter setDateFormat: @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    [utcDateFormatter setTimeZone: [NSTimeZone localTimeZone]];
    
    NSString *dateTimeString = [utcDateFormatter stringFromDate:[NSDate date]];
    
    return dateTimeString;
}
@end

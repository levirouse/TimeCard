//
//  NSTextView+DisableWordWrap.m
//  TimeCard
//
//  Created by Levi Rouse on 9/20/13.
//  Copyright (c) 2015 Levi Rouse. All rights reserved.
//

#import "NSTextView+DisableWordWrap.h"

@implementation NSTextView (DisableWordWrap)

- (void) disableWordWrap {
    NSSize layoutSize = {1e7, 1e7};
    [self setMaxSize: layoutSize];
    
    NSTextContainer *textContainer = [self textContainer];
    [textContainer setWidthTracksTextView: NO];
    [textContainer setContainerSize: layoutSize];
    
    NSScrollView *scrollView = [self enclosingScrollView];
    [scrollView setHasVerticalScroller: YES];
    [scrollView setHasHorizontalScroller: YES];
    [scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
    
    [self setVerticallyResizable: YES];
    [self setHorizontallyResizable: YES];
}

@end

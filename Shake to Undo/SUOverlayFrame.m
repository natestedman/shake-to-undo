/* Copyright (c) 2011, Nate Stedman <natesm@gmail.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#import "SUOverlayFrame.h"

#import "SUAppDelegate.h"
#import "SUOverlayButton.h"

@implementation SUOverlayFrame

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self)
    {
        NSRect buttonRect = NSInsetRect([self bounds], OVERLAY_BUTTON_PADDING, OVERLAY_BUTTON_PADDING);
        buttonRect.size.height = buttonRect.size.height / 2.0 - OVERLAY_BUTTON_PADDING / 2.0;
        
        NSButton* cancel = [[SUOverlayButton alloc] initWithFrame:buttonRect];
        [cancel setTitle:@"Cancel"];
        [cancel setTarget:[NSApp delegate]];
        [cancel setAction:@selector(cancelOverlay:)];
        
        buttonRect.origin.y += buttonRect.size.height + OVERLAY_BUTTON_PADDING;
        NSButton* undo = [[SUOverlayButton alloc] initWithFrame:buttonRect];
        [undo setTitle:@"Undo"];
        [undo setTarget:[NSApp delegate]];
        [undo setAction:@selector(performUndo:)];
        
        [self addSubview:cancel];
        [self addSubview:undo];
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = NSInsetRect([self bounds], 1.0, 1.0);
    NSBezierPath* bezier = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10];
    [bezier setLineWidth:2.0];
    
    NSGradient* gradient = [[NSGradient alloc]
                            initWithStartingColor:[NSColor colorWithCalibratedRed:0.12 green:0.18 blue:0.34 alpha:0.5]
                            endingColor:[NSColor colorWithCalibratedRed:0.06 green:0.12 blue:0.29 alpha:0.5]];
    [gradient drawInBezierPath:bezier angle:270.0];
    
    [[NSColor colorWithCalibratedRed:0.72 green:0.75 blue:0.80 alpha:0.6] set];
    [bezier stroke];
}

@end

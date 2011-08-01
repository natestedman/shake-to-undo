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

#import <Quartz/Quartz.h>

#import "SUOverlayView.h"

#import "SUOverlayFrame.h"

@implementation SUOverlayView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self)
    {
        frameRect.origin.x = frameRect.size.width / 2.0 - OVERLAY_FRAME_WIDTH / 2.0;
        frameRect.origin.y = frameRect.size.height / 2.0 - OVERLAY_FRAME_HEIGHT / 2.0;
        frameRect.size.width = OVERLAY_FRAME_WIDTH;
        frameRect.size.height = OVERLAY_FRAME_HEIGHT;
        
        NSView* overlayFrame = [[SUOverlayFrame alloc] initWithFrame:frameRect];
        [self addSubview:overlayFrame];
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.8] set];
    NSRectFill([self bounds]);
}

@end

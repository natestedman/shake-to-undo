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

#import "SUOverlayButton.h"

@implementation SUOverlayButton

-(void)drawRect:(NSRect)dirtyRect
{
    // draw the dark outline
    NSRect rect = NSInsetRect([self bounds], 1.0, 1.0);
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:rect
                                                         xRadius:OVERLAY_BUTTON_RADIUS
                                                         yRadius:OVERLAY_BUTTON_RADIUS];
    
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.3] set];
    [path stroke];
    
    rect.size.height -= 2;
    rect.origin.y += 1;
    rect.size.width -= 2;
    rect.origin.x += 1;
    
    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.3] set];
    
    // draw the light outline
    path = [NSBezierPath bezierPathWithRoundedRect:rect 
                                           xRadius:OVERLAY_BUTTON_RADIUS - 1.0
                                           yRadius:OVERLAY_BUTTON_RADIUS - 1.0];
    [path stroke];
    
    // draw the glossy gradient
    NSGradient* gradient = [[NSGradient alloc]
                            initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:0.47 green:0.51 blue:0.61 alpha:0.3], 0.0,
                            [NSColor colorWithCalibratedRed:0.21 green:0.27 blue:0.40 alpha:0.3], 0.5,
                            [NSColor colorWithCalibratedRed:0.06 green:0.12 blue:0.29 alpha:0.3], 0.5,
                            nil];
    
    [gradient drawInBezierPath:path angle:90.0];
    
    // prepare for text drawing
    NSFont* font = [NSFont fontWithName:OVERLAY_FONT_NAME size:OVERLAY_FONT_SIZE];
    NSColor* color = [NSColor colorWithCalibratedWhite:0.0 alpha:0.7];
    NSDictionary* inset = [NSDictionary dictionaryWithObjectsAndKeys:
                           font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    color = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
    NSDictionary* white = [NSDictionary dictionaryWithObjectsAndKeys:
                           font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    
    NSString* label = [self title];
    NSSize size = [label sizeWithAttributes:white];
    
    // draw the inset text
    NSPoint position = NSMakePoint(rect.origin.x + rect.size.width / 2.0 - size.width / 2.0,
                                   rect.origin.y + rect.size.height / 2.0 - size.height / 2.0);
    position.y -= OVERLAY_INSET_OFFSET;
    [label drawAtPoint:position withAttributes:inset];
    
    // draw the white text
    position.y += OVERLAY_INSET_OFFSET;
    [label drawAtPoint:position withAttributes:white];
}

@end

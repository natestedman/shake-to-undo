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

#import "SUOverlayWindow.h"

#import "SUOverlayView.h"

extern void CGSNewConnection(void*, void*);
extern void CGSNewCIFilterByName(void*, CFStringRef, uint32_t*);
extern void CGSSetCIFilterValuesFromDictionary(void*, uint32_t, CFDictionaryRef);
extern void CGSAddWindowFilter(void*, NSInteger, uint32_t, int);

@implementation SUOverlayWindow

-(id)initForScreen:(NSScreen*)screen
{
    self = [super initWithContentRect:[screen frame]
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];
    
    if (self)
    {
        NSView* overlay = [[SUOverlayView alloc] initWithFrame:[[self contentView] bounds]];
        [[self contentView] addSubview:overlay];
        [self setLevel:NSScreenSaverWindowLevel];
        [self setOpaque:NO];
        
        // hack in some blur with private API nonsense
        void* connection;
        uint32_t filter;
        
        CGSNewConnection(NULL , &connection);
        
        CGSNewCIFilterByName(connection,
                             (CFStringRef)@"CIGaussianBlur",
                             &filter);
        NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
        
        CGSSetCIFilterValuesFromDictionary(connection, filter, (CFDictionaryRef)dict);
        
        CGSAddWindowFilter(connection, [self windowNumber], filter, 1);
    }
    
    return self;
}

@end

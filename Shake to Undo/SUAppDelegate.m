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

#import "SUAppDelegate.h"

#import "SUOverlayWindow.h"

@implementation SUAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"showOverlay"]];
    
    shakeCount = 0;
    overlayWindows = nil;
    
    // format status item
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:30.0];
    [statusItem setTitle:@"⌘Z"];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    // start motion sensor
    int code = smsStartup(NULL, NULL);
    if (code != SMS_SUCCESS)
    {
        NSLog(@"SMS error code %d", code);
    }
    
    smsGetData(&previous);
    
    // repeatedly get sensor data
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                             target:self
                                           selector:@selector(timerCallback:)
                                           userInfo:nil
                                            repeats:YES];
    
    // get app change notifications to switch back to previous app with overlay
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(appChanged:)
                                                               name:NSWorkspaceDidDeactivateApplicationNotification
                                                             object:nil];
}

-(void)appChanged:(NSNotification*)notification
{
    mostRecentApp = [[notification userInfo] valueForKey:NSWorkspaceApplicationKey];
}

-(void)cancelOverlay:(id)sender
{
    if (overlayWindows)
    {
        for (NSWindow* window in overlayWindows)
        {
            [window orderOut:self];
        }
        overlayWindows = nil;
    }
    
    [mostRecentApp activateWithOptions:0];
}

-(void)performUndo:(id)sender
{
    [self cancelOverlay:self];
    
    CGEventRef down = CGEventCreateKeyboardEvent(NULL, 6, true);
    CGEventRef up = CGEventCreateKeyboardEvent(NULL, 6, false);
    
    CGEventSetFlags(down, kCGEventFlagMaskCommand);
    CGEventSetFlags(up, kCGEventFlagMaskCommand);
    
    CGEventPost(kCGAnnotatedSessionEventTap, down);
    CGEventPost(kCGAnnotatedSessionEventTap, up);
}

-(void)timerCallback:(id)sender
{
    sms_acceleration accel;
    smsGetData(&accel);
    
    float difference = previous.x - accel.x + previous.y - accel.y + previous.z - accel.z;
    
    if (difference > ACCEL_THRESHOLD)
    {
        shakeCount += COUNT_PER_SHAKE;
    }
    
    if (shakeCount > COUNT_THRESHOLD)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"showOverlay"] boolValue])
        {
            if (overlayWindows == nil)
            {
                NSArray* screens = [NSScreen screens];
                overlayWindows = [[NSMutableArray alloc] initWithCapacity:[screens count]];
                
                for (NSScreen* screen in screens)
                {
                    NSWindow* window = [[SUOverlayWindow alloc] initForScreen:screen];
                    [window makeKeyAndOrderFront:self];
                    [overlayWindows addObject:window];
                }
            }
        }
        else
        {
            [self performUndo:self];
        }
        
        shakeCount = 0;
    }
    
    if (shakeCount > 0)
    {
        shakeCount--;
    }
    
    previous = accel;
}

@end

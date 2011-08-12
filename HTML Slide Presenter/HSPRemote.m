//
//  HSPRemote.m
//  HTML Slide Presenter
//
//  Created by Daniel Westendorf on 8/9/11.
//  Copyright 2011 Daniel Westendorf. All rights reserved.
//

#import "HSPRemote.h"
#import "HIDRemote.h"

@implementation HSPRemote

- (id)init
{
    self = [super init];
    if (self) {
        [self listen];
    }
    
    return self;
}

- (void)listen
{
    [[HIDRemote sharedHIDRemote] setDelegate:self];
	
    if ([[HIDRemote sharedHIDRemote] startRemoteControl:kHIDRemoteModeExclusiveAuto])
    {
        // Start successful
        //NSLog(@"started");
    }
    else
    {
        // Start failed
        //NSLog(@"start failed");
    }
}

- (void)hidRemote:(HIDRemote *)hidRemote eventWithButton:(HIDRemoteButtonCode)buttonCode isPressed:(BOOL)isPressed fromHardwareWithAttributes:(NSMutableDictionary *)attributes
{
	//NSLog(@"%@: Button with code %d %@", hidRemote, buttonCode, (isPressed ? @"pressed" : @"released"));
    if (isPressed) {
        switch (buttonCode) {
            case 3:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HSPPrevious" object:nil];
                break;
            case 4:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HSPNext" object:nil];
                break;
            case 5:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HSPPlayToggle" object:nil];
                break;
            default:
                break;
        }
    }
}


@end

//
//  main.m
//  HTML Slide Presenter
//
//  Created by Daniel Westendorf on 8/9/11.
//  Copyright 2011 Daniel Westendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>
#import "HSPRemote.h"

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}

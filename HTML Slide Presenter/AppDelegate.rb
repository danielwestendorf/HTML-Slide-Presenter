#
#  AppDelegate.rb
#  HTML Slide Presenter
#
#  Created by Daniel Westendorf on 8/9/11.
#  Copyright 2011 Daniel Westendorf. All rights reserved.
#


class AppDelegate
    attr_accessor :window, :webview, :open_url_window, :open_url_text_field, :open_url_open_button, :open_url_cancel_button
    
    def initialize
        NSNotificationCenter.defaultCenter.addObserver(self, selector:'next:', name:"HSPNext", object:nil)
        NSNotificationCenter.defaultCenter.addObserver(self, selector:'previous:', name:"HSPPrevious", object:nil)
        NSNotificationCenter.defaultCenter.addObserver(self, selector:'fullScreenToggle:', name:"HSPPlayToggle", object:nil)
    end
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
        @url = "http://www.coon-and-friends.com/html-slide-presenter.html"
        display_url
        HSPRemote.alloc.init
        tracking_area = NSTrackingArea.alloc.initWithRect(@webview.bounds, options:(NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp), owner:self, userInfo:nil)
        @webview.addTrackingArea(tracking_area)
        start_mouse_timer
        @mouse_last_moved = Time.now + 5
    end
    
    def open_url(sender)
        #open modal
        url_modal = SimpleModal.new(@window, @open_url_window)
        url_modal.add_outlet(@open_url_cancel_button) do
           nil 
        end
        url_modal.add_outlet(@open_url_open_button) do
            @url = @open_url_text_field.stringValue
            @url = "http://" + @url if @url.scan("://").length < 1 
            display_url
        end
        url_modal.show
    end
    
    def mouseMoved(event)
        @mouse_last_moved = Time.now
    end
    
    def mouseEntered(event)
        start_mouse_timer unless @mouse_timer && @mouse_timer.isValid
    end
    
    def mouseExited(event)
        @mouse_timer.invalidate if @mouse_timer
        @mouse_last_moved = Time.now + 5
    end
    
    def full_screen_toggle(sender)
        @window.toggleFullScreen(sender)
    end
    
    def windowDidEnterFullScreen(note)
        start_mouse_timer unless @mouse_timer && @mouse_timer.isValid
    end
    
    def display_url
        @webview.setMainFrameURL(@url)
    end
    
    def reload(sender)
        @webview.reload(sender)
    end
    
    def start_mouse_timer
        @mouse_timer = NSTimer.scheduledTimerWithTimeInterval 1.0,
        target: self,
        selector: 'check_mouse_activity:',
        userInfo: nil,
        repeats: true
    end
    
    def check_mouse_activity(timer)
        if @mouse_last_moved + 5 < Time.now
            @mouse_timer.invalidate
            NSCursor.setHiddenUntilMouseMoves(true)
        end
    end
    
    def next(note)
        event = NSEvent.keyEventWithType(NSKeyDown, location:NSMakePoint(0,0), modifierFlags:0, timestamp:0, windowNumber: @window.windowNumber, context:nil, characters:"", charactersIgnoringModifiers:nil, isARepeat:false, keyCode:124)
        NSApp.postEvent(event, atStart:false)
        #send the keyup event imediately afterwards
        event = NSEvent.keyEventWithType(NSKeyUp, location:NSMakePoint(0,0), modifierFlags:0, timestamp:0, windowNumber: @window.windowNumber, context:nil, characters:"", charactersIgnoringModifiers:nil, isARepeat:false, keyCode:124)
        NSApp.postEvent(event, atStart:false)
    end

    def previous(note)
        event = NSEvent.keyEventWithType(NSKeyDown, location:NSMakePoint(0,0), modifierFlags:0, timestamp:0, windowNumber: @window.windowNumber, context:nil, characters:"", charactersIgnoringModifiers:nil, isARepeat:false, keyCode:123)
        NSApp.postEvent(event, atStart:false)
        #send the keyup event imediately afterwards
        event = NSEvent.keyEventWithType(NSKeyUp, location:NSMakePoint(0,0), modifierFlags:0, timestamp:0, windowNumber: @window.windowNumber, context:nil, characters:"", charactersIgnoringModifiers:nil, isARepeat:false, keyCode:123)
        NSApp.postEvent(event, atStart:false)
    end

    def fullScreenToggle(note)
        full_screen_toggle(NSMenuItem.alloc.init)
    end
end


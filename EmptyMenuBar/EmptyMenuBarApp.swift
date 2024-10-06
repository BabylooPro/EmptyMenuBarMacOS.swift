//
//  EmptyMenuBarApp.swift
//  EmptyMenuBar
//
//  Created by Max Remy on 06.10.2024.
//

import SwiftUI

@main
struct EmptyMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // DEFINING SETTINGS SCENE BUT LEAVING IT EMPTY
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem? // REFERENCE TO STATUS ITEM IN MENU BAR
    var popover: NSPopover? // REFERENCE TO POPOVER WINDOW
    var eventMonitor: EventMonitor? // MONITOR FOR OUSIDE CLICKS

    func applicationDidFinishLaunching(_ notification: Notification) {
        // CONFIGURING MENU BAR ITEM
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "globe", accessibilityDescription: "Globe")
            button.action = #selector(togglePopover)
        }
        
        // CONFIGURING POPOVER (A SMALL POPUP WINDOW)
        popover = NSPopover()
        popover?.contentViewController = NSHostingController(rootView: PopoverContentView())
        popover?.behavior = .transient // MAKES POPOVER DISAPPEAR WHEN CLICKING OUTSIDE
        
        // SETUP EVENT MONITOR TO DETECT CLICKS OUSIDE POPOVER
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover?.isShown == true {
                strongSelf.popover?.performClose(nil)
            }
        }
    }

    // FUNCTION TO TOGGLE DISPLAY OF POPOVER
    @objc func togglePopover() {
        if let button = statusItem?.button, let popover = popover {
            // IF POPOVER IS ALREADY SHOWN, CLOSE IT; OTHERWISE, OPEN IT
            if popover.isShown {
                popover.performClose(nil)
                eventMonitor?.stop()
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                eventMonitor?.start()
            }
        }
    }
}

// MONITOR FOR CLICKS OUTSIDE POPOVER
class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}

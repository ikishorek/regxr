//
//  PreferencesWindowController.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
	
	let defaults = UserDefaults.standard

    override func windowDidLoad() {
        super.windowDidLoad()
		
		let theme = defaults.string(forKey: "theme")
    
		if let window = window, let theme = theme {
			if (theme == "Light") {
				window.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
			} else {
				window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
			}
			window.titleVisibility = NSWindow.TitleVisibility.hidden;
			window.titlebarAppearsTransparent = true;
			window.styleMask.insert(.fullSizeContentView)
			window.isOpaque = false
			window.invalidateShadow()
			window.center()
			window.makeKeyAndOrderFront(nil)
		}
		
		NSApp.activate(ignoringOtherApps: true)
    }	
	
}

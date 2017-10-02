//
//  AppDelegate.swift
//  Minimal
//
//  Created by Luka Kerr on 23/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Main window
		let window = NSApplication.shared.windows.first!

		// Title bar properties
		window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
		window.titleVisibility = NSWindow.TitleVisibility.hidden;
		window.titlebarAppearsTransparent = true;
		window.styleMask.insert(.fullSizeContentView)
		window.isOpaque = false
		window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
		window.invalidateShadow()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		
	}

}

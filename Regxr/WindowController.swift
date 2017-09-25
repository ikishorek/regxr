//
//  WindowController.swift
//  Regxr
//
//  Created by Luka Kerr on 24/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
	
	let defaults = UserDefaults.standard
	
	override func windowDidLoad() {
        super.windowDidLoad()
		
		let theme = defaults.string(forKey: "theme")
		if let window = window, let theme = theme {
			setWindowColor(theme: theme)
			window.titleVisibility = NSWindow.TitleVisibility.hidden;
			window.titlebarAppearsTransparent = true;
			window.styleMask.insert(.fullSizeContentView)
			window.isOpaque = false
			window.invalidateShadow()
		}
		
    }
	
	func setWindowColor(theme: String) {
		if (theme == "Light") {
			window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
		} else {
			window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
		}
	}

}

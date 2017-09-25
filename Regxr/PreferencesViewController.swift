//
//  PreferencesViewController.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
	
	@IBOutlet weak var themeButton: NSSegmentedControl!
	@IBOutlet weak var referencesManualCheckbox: NSButton!
	
	let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
		if (theme == "Light") {
			themeButton.selectedSegment = 0
		} else {
			themeButton.selectedSegment = 1
		}
		
		let showReferenceOnStartup = defaults.bool(forKey: "showReference")
		referencesManualCheckbox.state = showReferenceOnStartup ? .on : .off
    }
	
	var wc = WindowController()
	
	@IBAction func themeChanged(_ sender: NSSegmentedControl) {
		let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
		var chosenTheme = theme
		if (sender.selectedSegment == 0) {
			// Light theme chosen
			chosenTheme = "Light"
			self.view.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
		} else {
			chosenTheme = "Dark"
			self.view.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
		}
		wc.setWindowColor(theme: chosenTheme)
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeThemeNotification"), object: chosenTheme)
		
		defaults.setValue(chosenTheme, forKey: "theme")
	}
	
	@IBAction func referenceManualChecked(_ sender: NSButton) {
		if (sender.state.rawValue == 0) {
			let show = false
			defaults.setValue(show, forKey: "showReference")
		} else {
			let show = true
			defaults.setValue(show, forKey: "showReference")
		}
	}
}

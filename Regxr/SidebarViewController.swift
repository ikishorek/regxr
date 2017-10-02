//
//  SidebarViewController.swift
//  Regxr
//
//  Created by Luka Kerr on 24/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa
import WebKit

class SidebarViewController: NSViewController, NSWindowDelegate {
	
	@IBOutlet weak var referenceView: WebView!
	@IBOutlet weak var backgroundView: NSVisualEffectView!
	
	let defaults = UserDefaults.standard
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.setThemeColor), name: NSNotification.Name(rawValue: "changeThemeNotification"), object: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		referenceView.drawsBackground = false
		let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
		
		setReferenceView(theme: theme)
		setThemeColor(notification: nil)
	}
	
	@objc func setThemeColor(notification: Notification?) {
		var theme = notification?.object as? String ?? defaults.string(forKey: "theme")
		if theme == nil {
			theme = DEFAULT_THEME
		}
		if let theme = theme {
			switch theme {
			case "Light":
				backgroundView.material = .mediumLight
			default:
				backgroundView.material = .ultraDark
			}
			setReferenceView(theme: theme)
		}
	}
	
	func setReferenceView(theme: String) {
		if let filePath = Bundle.main.path(forResource: "reference", ofType: "html") {
			
			var contentToAppend: String
			
			switch theme {
			case "Light":
				contentToAppend = "<style>body{color:#444;}</style></body></html>"
			default:
				contentToAppend = "<style>body{color:#CCC;}</style></body></html>"
			}
			
			// Check if file exists
			if let fileHandle = FileHandle(forWritingAtPath: filePath) {
				fileHandle.seekToEndOfFile()
				fileHandle.write(contentToAppend.data(using: String.Encoding.utf8)!)
			}
			
			referenceView.mainFrameURL = filePath
		}
	}
}

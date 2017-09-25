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
		
		if (theme == "Light") {
			backgroundView.material = .mediumLight
		} else {
			backgroundView.material = .ultraDark
		}
	}
	
	@objc func setThemeColor(notification: Notification?) {
		let theme = notification?.object as? String ?? defaults.string(forKey: "theme")
		if let theme = theme {
			print(theme)
			if (theme == "Light") {
				backgroundView.material = .mediumLight
			} else {
				backgroundView.material = .ultraDark
			}
			setReferenceView(theme: theme)
		}
	}
	
	func setReferenceView(theme: String) {
		if let filePath = Bundle.main.path(forResource: "reference", ofType: "html") {
			
			var contentToAppend: String
			
			if (theme == "Light") {
				contentToAppend = "<style>body{color:#555;}</style></body></html>"
			} else {
				contentToAppend = "<style>body{color:#CCC;}</style></body></html>"
			}
			
			//Check if file exists
			if let fileHandle = FileHandle(forWritingAtPath: filePath) {
				fileHandle.seekToEndOfFile()
				fileHandle.write(contentToAppend.data(using: String.Encoding.utf8)!)
			}
			
			referenceView.mainFrameURL = filePath
		}
	}
}

//
//  SidebarViewController.swift
//  Regxr
//
//  Created by Luka Kerr on 24/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa
import Foundation
import WebKit

class SidebarViewController: NSViewController, NSWindowDelegate {
	
	@IBOutlet weak var referenceView: WebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		referenceView.drawsBackground = false
		if let filePath = Bundle.main.path(forResource: "reference", ofType: "html") {
			referenceView.mainFrameURL = filePath
		}
	}
}

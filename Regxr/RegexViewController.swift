//
//  ViewController.swift
//  Minimal
//
//  Created by Luka Kerr on 23/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

let DEFAULT_THEME = "Light"
let DEFAULT_SHOW_REFERENCE = true

class RegexViewController: NSViewController, NSWindowDelegate {
	
	@IBOutlet var regexInput: NSTextView!
	@IBOutlet var textOutput: NSTextView!
	@IBOutlet weak var invalidLabel: NSTextField!
	@IBOutlet weak var topHalf: NSVisualEffectView!
	@IBOutlet weak var bottomHalf: NSVisualEffectView!
	@IBOutlet weak var referenceButton: NSButton!
	
	let defaults = UserDefaults.standard
	let highlighter = Regex()
	
	@objc dynamic var regexTextInput: String = "" {
		didSet {
			setRegexInputColor(notification: nil)
		}
	}
	
	@objc private var attributedRegexTextInput: NSAttributedString {
		get { return NSAttributedString(string: self.regexTextInput) }
		set { self.regexTextInput = newValue.string }
	}
	
	@objc dynamic var textInput: String = "" {
		didSet {
			let attr = setRegexHighlight(regex: regexInput.textStorage?.string, text: self.textInput, event: nil)
			setOutputHighlight(attr: attr)
			setRegexInputColor(notification: nil)
		}
	}
	
	@objc private var attributedTextInput: NSAttributedString {
		get { return NSAttributedString(string: self.textInput) }
		set { self.textInput = newValue.string }
	}
	
	// Needed because NSTextView only has an "Attributed String" binding
	@objc private static let keyPathsForValuesAffectingAttributedTextInput: Set<String> = [
		#keyPath(textInput),
		#keyPath(regexTextInput)
	]
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		defaults.set(true, forKey: "showReference")
		
		if let splitViewController = self.parent as? NSSplitViewController {
			let showReferenceOnStartup = defaults.bool(forKey: "showReference")
			let splitViewItem = splitViewController.splitViewItems

			if (showReferenceOnStartup) {
				splitViewItem.last!.isCollapsed = false
			} else {
				splitViewItem.last!.isCollapsed = true
			}
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.setThemeColor), name: NSNotification.Name(rawValue: "changeThemeNotification"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.setRegexInputColor), name: NSNotification.Name(rawValue: "changeThemeNotification"), object: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
			self.keyDown(with: aEvent)
			return aEvent
		}

		setThemeColor(notification: nil)
	}
	
	// Set color for regex input when regex is syntax highlighted
	@objc func setRegexInputColor(notification: Notification?) {
		var theme = notification?.object as? String ?? defaults.string(forKey: "theme")
		if theme == nil {
			theme = DEFAULT_THEME
		}
		if let theme = theme {
			let highlightedText = highlighter.highlight(string: self.regexTextInput, theme: theme)
			regexInput.textStorage?.mutableString.setString("")
			regexInput.textStorage?.append(highlightedText)
		}
	}
	
	@objc func setThemeColor(notification: Notification?) {
		var theme = notification?.object as? String ?? defaults.string(forKey: "theme")
		if theme == nil {
			theme = DEFAULT_THEME
		}
		if let theme = theme {
			if (theme == "Light") {
				self.view.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
				topHalf.material = .light
				bottomHalf.material = .mediumLight
				regexInput.textColor = NSColor.black
				textOutput.textColor = NSColor.black
			} else {
				self.view.window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
				topHalf.material = .dark
				bottomHalf.material = .ultraDark
				regexInput.textColor = NSColor.white
				textOutput.textColor = NSColor.white
			}
		}
		regexInput.font = NSFont(name: "Monaco", size: 15)
		textOutput.font = NSFont(name: "Monaco", size: 15)
	}
	
	func matches(for regex: String, in text: String) -> [NSTextCheckingResult] {
		do {
			invalidLabel.stringValue = ""
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
			return results
		} catch _ {
			if (regex.count > 0) {
				invalidLabel.stringValue = "Expression is invalid"
			}
			return []
		}
	}
	
	func setOutputHighlight(attr: NSMutableAttributedString) {
		let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
		
		if (theme == "Light") {
			regexInput.textColor = NSColor.black
			textOutput.textColor = NSColor.black
			attr.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor.black, range: NSRange(location: 0, length: attr.length))
		} else {
			regexInput.textColor = NSColor.white
			textOutput.textColor = NSColor.white
			attr.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: attr.length))
		}
		
		textOutput.textStorage?.mutableString.setString("")
		textOutput.textStorage?.append(attr)
		textOutput.font = NSFont(name: "Monaco", size: 15)
	}
	
	func setRegexHighlight(regex regexInput: String?, text textInput: String?, event: NSEvent?) -> NSMutableAttributedString {
		let topBox = regexInput
		let bottomBox = textInput
		let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
		
		if let topBox = topBox, let bottomBox = bottomBox {
			var foundMatches : [NSTextCheckingResult] = []
			// If backspace, drop backspace character from regex
			// Otherwise get topBox regex and current key character
			if let event = event {
				if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
					foundMatches = matches(for: String(topBox.characters.dropLast()), in: bottomBox)
				} else {
					foundMatches = matches(for: topBox + String(describing: event.characters!), in: bottomBox)
				}
			} else {
				foundMatches = matches(for: topBox, in: bottomBox)
			}
			
			let attribute = NSMutableAttributedString(string: bottomBox)
			let attributeLength = attribute.string.characters.count
			
			var newColor = false
			
			for match in foundMatches {
				var range = match.range(at: 0)
				var index = bottomBox.index(bottomBox.startIndex, offsetBy: range.location + range.length)
				var outputStr = String(bottomBox[..<index])
				index = bottomBox.index(bottomBox.startIndex, offsetBy: range.location)
				outputStr = String(outputStr.suffix(from: index))
				let matchLength = outputStr.count
				
				if (newColor) {
					if (theme == "Light") {
						attribute.addAttribute(NSAttributedStringKey.backgroundColor, value: NSColor(red:0.86, green:0.58, blue:0.99, alpha:1.00), range: NSRange(location: range.location, length: matchLength))
					} else {
						attribute.addAttribute(NSAttributedStringKey.backgroundColor, value: NSColor(red: 0.60, green: 0.26, blue: 0.77, alpha: 1), range: NSRange(location: range.location, length: matchLength))
					}
					range = NSMakeRange(range.location + range.length, attributeLength - (range.location + range.length))
					newColor = false
				} else {
					if (theme == "Light") {
						attribute.addAttribute(NSAttributedStringKey.backgroundColor, value: NSColor(red:0.59, green:0.87, blue:0.97, alpha:1.00), range: NSRange(location: range.location, length: matchLength))
					} else {
						attribute.addAttribute(NSAttributedStringKey.backgroundColor, value: NSColor(red: 0.25, green: 0.51, blue: 0.77, alpha: 1), range: NSRange(location: range.location, length: matchLength))
					}
					range = NSMakeRange(range.location + range.length, attributeLength - (range.location + range.length))
					newColor = true
				}
			}
			return attribute
		}
		let empty = NSMutableAttributedString(string: "")
		return empty
	}
	
	override func keyDown(with event: NSEvent) {
		let attr = setRegexHighlight(regex: regexInput.textStorage?.string, text: textOutput.textStorage?.string, event: event)
		setOutputHighlight(attr: attr)
	}
	
	@IBAction func referenceButtonClicked(_ sender: NSButton) {
		if let splitViewController = self.parent as? NSSplitViewController {
			let splitViewItem = splitViewController.splitViewItems
			
			splitViewItem.last!.collapseBehavior = .preferResizingSplitViewWithFixedSiblings
			splitViewItem.last!.animator().isCollapsed = !splitViewItem.last!.isCollapsed
		}
	}

	override var representedObject: Any? {
		didSet {
		
		}
	}

}


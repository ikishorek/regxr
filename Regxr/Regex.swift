//
//  RegexHighlighter.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class Regex {
	func highlight(string: String, theme: String) -> NSMutableAttributedString {
		let purpleFoundMatches = matches(for: "\\(|\\)|\\?|\\+|\\*|\\^|\\{|\\}|\\||\\.|\\^|\\$|\\\\", in: string)
		let blueFoundMatches = matches(for: "\\\\w|\\\\t|\\\\n|\\\\d|\\\\s|\\[|\\]|\\\\D|\\\\S|\\\\W", in: string)
		
		let attribute = NSMutableAttributedString(string: string)
		let attributeLength = attribute.string.characters.count
		
		switch theme {
		case "Light":
			attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor.black, range: NSRange(location: 0, length: attribute.length))
		default:
			attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: attribute.length))
		}
		
		for match in purpleFoundMatches {
			var range = match.range(at: 0)
			var index = string.index(string.startIndex, offsetBy: range.location + range.length)
			var outputStr = String(string[..<index])
			index = string.index(string.startIndex, offsetBy: range.location)
			outputStr = String(outputStr.suffix(from: index))
			let matchLength = outputStr.count
			
			attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor(red: 0.60, green: 0.26, blue: 0.77, alpha: 1), range: NSRange(location: range.location, length: matchLength))
			range = NSMakeRange(range.location + range.length, attributeLength - (range.location + range.length))
		}
		
		for match in blueFoundMatches {
			var range = match.range(at: 0)
			var index = string.index(string.startIndex, offsetBy: range.location + range.length)
			var outputStr = String(string[..<index])
			index = string.index(string.startIndex, offsetBy: range.location)
			outputStr = String(outputStr.suffix(from: index))
			let matchLength = outputStr.count
			
			attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor(red: 0.25, green: 0.51, blue: 0.77, alpha: 1), range: NSRange(location: range.location, length: matchLength))
			range = NSMakeRange(range.location + range.length, attributeLength - (range.location + range.length))
		}
		
		attribute.addAttributes([NSAttributedStringKey.font: NSFont(name: "Monaco", size: 15)!], range: NSRange(location: 0, length: attribute.length))
		return attribute
	}
	
	func matches(for regex: String, in text: String) -> [NSTextCheckingResult] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			return regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
		} catch _ {
			return []
		}
	}
}

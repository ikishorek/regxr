//
//  AppDelegate.swift
//  Regxr
//
//  Created by Luka Kerr on 23/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  
  let defaults = UserDefaults.standard
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Main window
    let window = NSApplication.shared.windows.first!
    
    let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
    
    if (theme == "Light") {
      window.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
    } else {
      window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
    }
    
    // Title bar properties
    window.titleVisibility = NSWindow.TitleVisibility.hidden;
    window.titlebarAppearsTransparent = true;
    window.styleMask.insert(.fullSizeContentView)
    window.isOpaque = false
    window.invalidateShadow()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    
  }
  
}

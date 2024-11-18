//
//  EasyRentApp.swift
//  EasyRent
//
//  Created by Roman Hural on 14.09.2024.
//

import SwiftUI

@main
/// The main entry point to the application
struct EasyRentApp: App {
    /// Property that redirecting project launch to AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    /// Body of the main entry
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

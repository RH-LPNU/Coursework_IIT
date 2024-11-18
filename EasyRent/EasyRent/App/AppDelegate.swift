//
//  AppDelegate.swift
//  EasyRent
//
//  Created by Roman Hural on 14.09.2024.
//

import SwiftUI
import FirebaseCore

/// Class used for launching the project and configuring Firebase Database
class AppDelegate: NSObject, UIApplicationDelegate {
    /// Function that launches the project and configures the project database
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

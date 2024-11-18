//
//  SettingsViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation

/// Class that manages the business logic of the Settings Screen
@MainActor
final class SettingsViewModel: ObservableObject {
    
    /// Functions that signs out the user
    func signOut() throws {
        try AuthentificationManager.shared.signOut()
    }
}

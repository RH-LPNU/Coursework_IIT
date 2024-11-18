//
//  SettingsView.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// SettingsView Screen
struct SettingsView: View {
    /// Property that contains view model of the settings screen
    @StateObject private var viewModel = SettingsViewModel()
    /// Property that checks whether or not show AuthentificationView
    @Binding var showSignInView: Bool
    
    /// Describes the Settings Screen interface
    var body: some View {
        List {
            Section("Manage Account") {
                VStack(alignment: .center) {
                    Button("Log Out") {
                        Task {
                            do {
                                try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                print("Error", error)
        //                        showSignInView = false
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

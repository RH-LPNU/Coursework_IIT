//
//  SignInEmailViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation

/// Signing in with email class that manages business logic
@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    /// Property that contains user email
    @Published var email: String = ""
    /// Property that contains user password
    @Published var password: String = ""
    
    /// Function that sign up the user to the account
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password entered")
            return
        }
        let _ = try await AuthentificationManager.shared.signInUserWith(email, and: password)
    }
}

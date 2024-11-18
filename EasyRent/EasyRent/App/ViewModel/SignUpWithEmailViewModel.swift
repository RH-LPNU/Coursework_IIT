//
//  SignUpWithEmailViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation

/// Signing up with email class that manages business logic
@MainActor
final class SignUpWithEmailViewModel: ObservableObject {
    
    /// Property that contains user first name
    @Published var firstName: String = ""
    /// Property that contains user last name
    @Published var lastName: String = ""
    /// Property that contains user email
    @Published var email: String = ""
    /// Property that contains user password
    @Published var password: String = ""
    
    /// Function that sign up the user to the account
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            print("No email or password entered")
            return
        }
        let authData = try await AuthentificationManager.shared.createUserWith(email, and: password)
        let user = DBUser(authData: authData, firstName: firstName, lastName: lastName, isAdmin: email.lowercased() == "roman162002@gmail.com" ? true : false)

        try await UserManager.shared.createUser(user: user)
    }
}

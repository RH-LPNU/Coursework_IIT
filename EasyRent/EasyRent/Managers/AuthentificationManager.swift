//
//  AuthentificationManager.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation
import FirebaseAuth

/// Firebase Authentification Manager
final class AuthentificationManager {
    
    /// Property that creates singleton pattern
    static let shared = AuthentificationManager()
    private init() { }
    
    /// Function that registers user account via Firebase Authentification
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    /// - Returns: Auth data result model in order to use it through the application to omit every time sign in
    func createUserWith(_ email: String, and password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    /// Function that signs into user account via Firebase Authentification
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    /// - Returns: Auth data result model in order to use it through the application to omit every time sign in
    func signInUserWith(_ email: String, and password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
//    func resetPasswordFor(_ email: String) async throws {
//        try await Auth.auth().sendPasswordReset(withEmail: email)
//    }
    
    /// Function that signs out the user from the application via Firebase Authentification
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    /// Function that retrieves information about user who authentificated to the applicationr
    /// - Returns: Auth data result model in order to use it through the application to omit every time sign in
    func getAuthentificatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
}

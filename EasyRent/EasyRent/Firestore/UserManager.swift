//
//  UserManager.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation
import FirebaseFirestore


/// Firestore Database User Table Manager
final class UserManager {
    
    /// Property that creates singleton pattern
    static let shared = UserManager()
    private init() { }
    
    /// Property that contains reference to the Firestore Database Users Table
    private let userCollection = Firestore.firestore().collection("users")
    
    /// Function that creates reference to the specific user in the Users Table
    /// - Parameter userId: unique user id
    /// - Returns: Reference to the specific user in the Users Table
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    /// Function that creates new user in the Firestore Database Users Table
    /// - Parameter user: User data model
    func createUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    /// Function that retrieves specific user from Firestore Database Users Table
    /// - Parameter id: Unique user id
    /// - Returns: User data model
    func getUser(withID id: String) async throws -> DBUser {
        try await userDocument(userId: id).getDocument(as: DBUser.self)
    }
    
    func updateItems(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    /// Function that retrieves speicific user by email
    /// - Parameter email: User email
    /// - Returns: User data model
    func fetchUserWithEmail(_ email: String) async throws -> DBUser? {
        let query = userCollection.whereField(DBUser.CodingKeys.email.rawValue, isEqualTo: email)
        let snapshot = try await query.getDocuments()
        
        return try snapshot.documents.first?.data(as: DBUser.self)
    }
    
    /// Function that returns all users in array from Firebase Database
    /// - Returns: Array of DBUser
    func fetchUsers() async throws -> [DBUser] {
        let snapshot = try await userCollection.getDocuments()
        
        var users = [DBUser]()
        for document in snapshot.documents {
            var user = try document.data(as: DBUser.self)
            users.append(user)
        }
        
        return users
    }
}

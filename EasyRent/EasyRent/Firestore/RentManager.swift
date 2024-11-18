//
//  OrderManager.swift
//  EasyRent
//
//  Created by Roman Hural on 21.09.2024.
//

import Foundation
import FirebaseFirestore


/// Firestore Database Rents Table Manager
class RentManager {
    /// Property that creates singleton pattern
    static let shared = RentManager()
    private init() { }
    
    /// Property that contains reference to the Firestore Database Rents Table
    private let rentCollection = Firestore.firestore().collection("rents")
    
    /// Function that creates reference to the specific rent in the Rents Table
    /// - Parameter rentId: unique rent id
    /// - Returns: Reference to the specific rent in the Rents Table
    private func rentColletionReference(_ rentId: String) -> DocumentReference {
        rentCollection.document(rentId)
    }
    
    /// Function that creates new rent in the Firestore Database Rents Table
    /// - Parameters:
    ///   - rent: Rent data model
    ///   - rentId: Unique rent id
    func createRent(_ rent: Rent, rentId: String) async throws {
        try rentColletionReference(rentId).setData(from: rent, merge: false)
    }
    
    /// Function that updates rent in the Firestore Database Rents Table
    /// - Parameters:
    ///   - rentID: Unique id of the rent that should be updated
    ///   - status: Rent Status
    ///   - actualReturnDate: The date, when rent is completed
    func updateRentFor(rentID: String, status: RentState, actualReturnDate: Date) async throws{
        let data: [String : Any] = [
            Rent.CodingKeys.state.rawValue : status.rawValue,
            Rent.CodingKeys.actualReturnDate.rawValue : actualReturnDate
        ]
        try await rentColletionReference(rentID).updateData(data)
    }
    
    /// Function that fetches rents for all users and returns them in the array
    /// - Returns: Array of all rents from Firestore Database Rents Table
    func fetchAllRents() async throws -> [Rent] {
        let snapshot = try await rentCollection.getDocuments()
        
        var rents = [Rent]()
        for document in snapshot.documents {
            var rent = try document.data(as: Rent.self)
            if let uuidFromString = UUID(uuidString: document.documentID) {
                rent.id = uuidFromString
                rents.append(rent)
            }
        }
        
        return rents
    }
    
    /// Function that fetches rents for specific user and returns them in the array
    /// - Parameter userId: Unique user id
    /// - Returns: Array of specific user rents from Firestore Database Rents Table
    func fetchUserRents(userId: String) async throws -> [Rent] {
        let query = rentCollection.whereField(Rent.CodingKeys.userId.rawValue, isEqualTo: userId)
        let snapshot = try await query.getDocuments()
        
        var rents = [Rent]()
        for document in snapshot.documents {
            var rent = try document.data(as: Rent.self)
            if let uuidFromString = UUID(uuidString: document.documentID) {
                rent.id = uuidFromString
                rents.append(rent)
            }
        }
        
        return rents
    }
}

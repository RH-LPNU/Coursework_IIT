//
//  Storage.swift
//  EasyRent
//
//  Created by Roman Hural on 25.10.2024.
//

import Foundation
import FirebaseStorage


/// FirebaseStorage Manager
class FirebaseStorage {
    /// Property that creates singleton pattern
    static let shared = FirebaseStorage()
//    private init() {}
    
    /// Function that performs image deletion from Firebase Storage
    /// - Parameter urlString: image url in string format that will be deleted
    func deleteImageFor(urlString: String?) async throws {
        guard let urlString else { return }
        
        if let rangeStart = urlString.range(of: "images%2F"),
           let rangeEnd = urlString.range(of: ".jpg") ??
                             urlString.range(of: ".jpeg") ??
                             urlString.range(of: ".png") {
            let extractedText = urlString[rangeStart.upperBound..<rangeEnd.upperBound]
            
            let storageRef = Storage.storage().reference().child("images/\(extractedText)")
            
            do {
                try await storageRef.delete()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

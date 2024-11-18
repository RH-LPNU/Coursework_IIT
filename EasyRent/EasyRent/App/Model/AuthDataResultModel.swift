//
//  AuthDataResultModel.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation
import FirebaseAuth

/// Auth Data Result Model
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

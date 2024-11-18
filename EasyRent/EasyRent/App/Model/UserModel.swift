//
//  UserModel.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation

/// User Data Model
struct DBUser: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let userId: String
    let firstName: String
    let lastName: String
    var isAdmin: Bool
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    var items: [ItemModel]? = []
    
    init(authData: AuthDataResultModel, firstName: String, lastName: String, isAdmin: Bool) {
        self.userId = authData.uid
        self.firstName = firstName
        self.lastName = lastName
        self.isAdmin = isAdmin
        self.email = authData.email
        self.photoURL = authData.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.items = []
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isAdmin = "is_admin"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case items = "items"
    }
    
    init(from decoder: any Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        self.userId         = try container.decode(String.self, forKey: .userId)
        self.firstName      = try container.decode(String.self, forKey: .firstName)
        self.lastName       = try container.decode(String.self, forKey: .lastName)
        self.isAdmin        = try container.decode(Bool.self, forKey: .isAdmin)
        self.email          = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL       = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated    = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium      = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.items          = try container.decodeIfPresent([ItemModel].self, forKey: .items)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.isAdmin, forKey: .isAdmin)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.items, forKey: .items)
    }
    
//    init(userId: String,
//         email: String? = nil,
//         photoURL: String? = nil,
//         dateCreated: Date? = nil,
//         isPremium: Bool? = nil,
//         items: [ItemModel]? = nil) {
//        self.userId = userId
//        self.email = email
//        self.photoURL = photoURL
//        self.dateCreated = dateCreated
//        self.isPremium = isPremium
//        self.items = items
//    }
}

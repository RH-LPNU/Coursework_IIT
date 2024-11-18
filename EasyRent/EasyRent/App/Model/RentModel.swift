//
//  RentModel.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation

/// Enum that defines rent state cases
enum RentState: String, Codable, Hashable {
    case inUse = "in_use"
    case finished
}

/// Rent Data Model
struct Rent: Codable, Identifiable, Hashable {
    var id = UUID()
    
    let state: RentState
    let userId: String
    let itemId: String
    let itemName: String
    let rentDate: Date
    let deadlineReturnDate: Date
    let actualReturnDate: Date?
    let hoursInRent: Int
    let pricePerHour: Int
    let totalPrice: Int
    let additionalFee: Int?
    
    init(state: RentState,
         userId: String,
         itemId: String,
         itemName: String,
         pricePerHour: Int,
         rentDate: Date,
         deadlineReturnDate: Date,
         actualReturnDate: Date? = nil,
         hoursInRent: Int,
         totalPrice: Int,
         additionalFee: Int? = nil) {
        self.state = state
        self.userId = userId
        self.itemId = itemId
        self.itemName = itemName
        self.rentDate = rentDate
        self.deadlineReturnDate = deadlineReturnDate
        self.actualReturnDate = actualReturnDate
        self.hoursInRent = hoursInRent
        self.pricePerHour = pricePerHour
        self.totalPrice = totalPrice
        self.additionalFee = additionalFee
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
        self.state = try container.decode(RentState.self, forKey: .state)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.itemId = try container.decode(String.self, forKey: .itemId)
        self.itemName = try container.decode(String.self, forKey: .itemName)
        self.rentDate = try container.decode(Date.self, forKey: .rentDate)
        self.deadlineReturnDate = try container.decode(Date.self, forKey: .deadlineReturnDate)
        self.actualReturnDate = try container.decodeIfPresent(Date.self, forKey: .actualReturnDate)
        self.hoursInRent = try container.decode(Int.self, forKey: .hoursInRent)
        self.pricePerHour = try container.decode(Int.self, forKey: .pricePerHour)
        self.totalPrice = try container.decode(Int.self, forKey: .totalPrice)
        self.additionalFee = try container.decodeIfPresent(Int.self, forKey: .additionalFee)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.itemId, forKey: .itemId)
        try container.encode(self.itemName, forKey: .itemName)
        try container.encode(self.rentDate, forKey: .rentDate)
        try container.encode(self.deadlineReturnDate, forKey: .deadlineReturnDate)
        try container.encodeIfPresent(self.actualReturnDate, forKey: .actualReturnDate)
        try container.encode(self.hoursInRent, forKey: .hoursInRent)
        try container.encode(self.pricePerHour, forKey: .pricePerHour)
        try container.encode(self.totalPrice, forKey: .totalPrice)
        try container.encodeIfPresent(self.additionalFee, forKey: .additionalFee)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case state
        case userId = "user_id"
        case itemId = "item_id"
        case itemName = "item_name"
        case rentDate = "rent_date"
        case deadlineReturnDate = "deadline_return_date"
        case actualReturnDate = "actual_return_date"
        case hoursInRent = "hours_in_rent"
        case pricePerHour = "price_per_hour"
        case totalPrice = "total_price"
        case additionalFee = "additional_fee"
    }
}

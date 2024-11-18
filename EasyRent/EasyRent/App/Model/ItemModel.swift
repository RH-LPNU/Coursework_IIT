//
//  ItemModel.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation
import FirebaseFirestore


/// Enum that defines item availability state cases
enum ItemState: String, Codable, Hashable {
    case available
    case rented
}


/// Item Data Model
struct ItemModel: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    var pricePerHour: Int
    var state: ItemState
    var dateRegistrated: Date
    var rentedByUserWithId: String?
    var orderID: String?
    var hoursInRent: Int?
    var dateRent: Date?
    var dateReturn: Date?
    var category: ItemCategory?
    var imageURLString: String?
    
    var priceForRent: Int? {
        pricePerHour * (hoursInRent ?? 0)
    }
    
    init(name: String,
         pricePerHour: Int,
         state: ItemState,
         dateRegistrated: Date,
         rentedByUserWithId: String? = nil,
         orderID: String? = nil,
         hoursInRent: Int? = nil,
         dateRent: Date? = nil,
         dateReturn: Date? = nil,
         category: ItemCategory? = nil,
         imageURLString: String? = nil) {
        self.name = name
        self.pricePerHour = pricePerHour
        self.state = state
        self.dateRegistrated = dateRegistrated
        self.rentedByUserWithId = rentedByUserWithId
        self.orderID = orderID
        self.hoursInRent = hoursInRent
        self.dateRent = dateRent
        self.dateReturn = dateReturn
        self.category = category
        self.imageURLString = imageURLString
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.name               = try container.decode(String.self, forKey: .name)
        self.pricePerHour       = try container.decode(Int.self, forKey: .pricePerHour)
        self.state              = try container.decode(ItemState.self, forKey: .state)
        self.dateRegistrated    = try container.decode(Date.self, forKey: .dateRegistrated)
        self.rentedByUserWithId = try container.decodeIfPresent(String.self, forKey: .rentedByUserWithId)
        self.orderID            = try container.decodeIfPresent(String.self, forKey: .orderID)
        self.hoursInRent        = try container.decodeIfPresent(Int.self, forKey: .hoursInRent)
        self.dateRent           = try container.decodeIfPresent(Date.self, forKey: .dateRent)
        self.dateReturn         = try container.decodeIfPresent(Date.self, forKey: .dateReturn)
        self.category           = try container.decodeIfPresent(ItemCategory.self, forKey: .category)
        self.imageURLString     = try container.decodeIfPresent(String.self, forKey: .imageURLString)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self._id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.pricePerHour, forKey: .pricePerHour)
        try container.encode(self.state, forKey: .state)
        try container.encodeIfPresent(self.dateRegistrated, forKey: .dateRegistrated)
        try container.encodeIfPresent(self.rentedByUserWithId, forKey: .rentedByUserWithId)
        try container.encodeIfPresent(self.orderID, forKey: .orderID)
        try container.encodeIfPresent(self.hoursInRent, forKey: .hoursInRent)
        try container.encodeIfPresent(self.dateRent, forKey: .dateRent)
        try container.encodeIfPresent(self.dateReturn, forKey: .dateReturn)
        try container.encodeIfPresent(self.category, forKey: .category)
        try container.encodeIfPresent(self.imageURLString, forKey: .imageURLString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pricePerHour = "price_per_hour"
        case state
        case dateRegistrated = "date_registrated"
        case rentedByUserWithId = "rented_by_user_with_id"
        case orderID = "order_id"
        case hoursInRent = "hours_in_rent"
        case dateRent = "date_rent"
        case dateReturn = "date_return"
        case category
        case imageURLString = "image_url_string"
    }
//    static func mockData() -> [ItemModel] {
//        [
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: nil),
//            ItemModel(name: "Scouter", pricePerHour: 200, state: .available, dateReturn: Date()),
//            ItemModel(name: "Skies", pricePerHour: 120, state: .available, dateReturn: Date()),
//            ItemModel(name: "Snowboard", pricePerHour: 130, state: .available, dateReturn: Date()),
//            ItemModel(name: "Tesla car", pricePerHour: 500, state: .rented, dateReturn: Date()),
//            ItemModel(name: "BMW car", pricePerHour: 450, state: .available, dateReturn: Date()),
//            ItemModel(name: "Motocycle", pricePerHour: 300, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .rented, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: nil),
//            ItemModel(name: "Scouter", pricePerHour: 200, state: .rented, dateReturn: Date()),
//            ItemModel(name: "Skies", pricePerHour: 120, state: .available, dateReturn: Date()),
//            ItemModel(name: "Snowboard", pricePerHour: 130, state: .available, dateReturn: Date()),
//            ItemModel(name: "Tesla car", pricePerHour: 500, state: .available, dateReturn: Date()),
//            ItemModel(name: "BMW car", pricePerHour: 450, state: .available, dateReturn: Date()),
//            ItemModel(name: "Motocycle", pricePerHour: 300, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .rented, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date()),
//            ItemModel(name: "Bike", pricePerHour: 100, state: .available, dateReturn: Date())
//        ]
//    }
}


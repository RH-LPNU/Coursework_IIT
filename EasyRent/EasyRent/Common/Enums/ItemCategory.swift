//
//  ItemCategory.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation

/// Enum for defining item category
enum ItemCategory: String, Codable, Hashable  {
    case all
    case sportInventory
    case camping
    case vehicles
    case other
    
    /// Functions that converts case of the enum into String format
    /// - Returns: String format of the category
    func categoryTitle() -> String {
        switch self {
        case .all:
            return ""
        case .sportInventory:
            return "Sport Inventory"
        case .camping:
            return "Camping"
        case .vehicles:
            return "Vehicles"
        case .other:
            return "Other"
        }
    }
}

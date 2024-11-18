//
//  SortedStyle.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation

/// Enum for defining items list sorting style
enum SortedStyle {
    case byRegistrationDateOldest
    case byRegistrationDateNewest
    case byNameAscending
    case byNameDescending
    case byPriceToLowest
    case byPriceToHighest
}

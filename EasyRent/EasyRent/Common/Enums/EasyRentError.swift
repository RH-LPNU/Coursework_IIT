//
//  EasyRentError.swift
//  EasyRent
//
//  Created by Roman Hural on 27.10.2024.
//

import Foundation

/// Enum for handling errors
enum EasyRentError: String, Error {
    case fieldsWithoutText = "Please, fill Name and Price fields of the Item"
}

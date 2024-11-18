//
//  RentRow.swift
//  EasyRent
//
//  Created by Roman Hural on 22.09.2024.
//

import SwiftUI

/// Structure of the row in the rents list
struct RentRow: View {
    /// Property that contains name of the rented item
    let itemName: String
    /// Property that contains price of the rented item
    let price: Int
    /// Property that contains hours in rent of the item
    let hoursInRent: Int
    /// Property that contains rent date of the item
    let rentDate: String
    /// Property that contains return date of the rented item
    let returnDate: String
    /// Property that contains rentain id
    let userID: String
    /// Property that contains actual return date of the rented item
    let actualReturnDate: String?
//    let itemPrice: Int
    
    /// Describes the rent row in the rents list interface
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Item Name:")
                        .fontWeight(.bold)
                    Text("\(itemName)")
                }
                HStack {
                    Text("Rent Date:")
                        .fontWeight(.bold)
                    Text("\(rentDate)")
                }
                HStack {
                    Text("Return Date:")
                        .fontWeight(.bold)
                    Text("\(returnDate)")
                }
                
                HStack {
                    Text("Price for \(hoursInRent) hour\(hoursInRent != 1 ? "s" : ""):")
                        .fontWeight(.bold)
                    Text("\(price) UAH")
                }
                HStack {
                    Text("Rentant:")
                        .fontWeight(.bold)
                    Text("\(userID)")
                        .font(.footnote)
                }
                
                if let actualReturnDate {
                    HStack {
                        Text("Actual Return Date:")
                            .fontWeight(.bold)
                        Text("\(actualReturnDate)")
                    }
                }
//                Text("\(itemPrice) UAH / Hour")
//                    .foregroundStyle(Color.black.opacity(0.9))
//                    .fontWeight(.medium)
//                    .padding(.vertical, 3)
//                    .padding(.horizontal, 5)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .foregroundStyle(Color.red.opacity(0.7))
//                    }
            }
            
            Spacer()
        }
    }
}

#Preview {
    RentRow(itemName: "Bike", price: 200, hoursInRent: 5, rentDate: "", returnDate: "", userID: "", actualReturnDate: "")
}

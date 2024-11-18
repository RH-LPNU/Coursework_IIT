//
//  ItemRow.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// Structure of the row in the items list
struct ItemRow: View {
//    let itemName: String
//    let itemPrice: Int
    //    let itemState: ItemState
    /// Item data model
    let itemModel: ItemModel
    
    /// Describes the item row in the items list interface
    var body: some View {
        HStack {
//            if let urlString = itemModel.imageURLString {
//                if let url = URL(string: urlString) {
////                    WebImage
//                    AsyncImage(url: url) { image in
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 40, height: 40)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                    } placeholder: {
//                        ProgressView()
//                    }
//                }
//            } else {
//                Image(.default)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 40, height: 40)
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//            }
            VStack {
                Text(itemModel.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .offset(y: 10)
                
//                Text("\(itemPrice) UAH / Hour")
//                    .foregroundStyle(Color.black.opacity(0.9))
//                    .fontWeight(.medium)
//                    .padding(.vertical, 3)
//                    .padding(.horizontal, 5)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .foregroundStyle(Color.red.opacity(0.7))
//                    }
                Text("\(itemModel.pricePerHour) UAH / Hour")
                    .foregroundStyle(Color.red)
                    .fontWeight(.bold)
                    .padding(.vertical, 3)
//                    .padding(.horizontal, 5)
//                    .padding()
            }
            
            Spacer()
            
            if itemModel.state == .available {
//                Text(LocalizedStringKey("Available"))
//                    .foregroundStyle(Color.black.opacity(0.9))
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 5)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .foregroundStyle(Color.green.opacity(0.6))
//                    }
//                    .padding()
                Text("Available")
                    .foregroundStyle(Color.green)
                    .fontWeight(.bold)
//                    .padding()
                
            } else if itemModel.state == .rented {
//                Text(LocalizedStringKey("Rented"))
//                    .foregroundStyle(Color.black.opacity(0.9))
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 5)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10.0)
//                            .foregroundStyle(Color.yellow.opacity(0.6))
//                    }
//                    .padding()
                
                Text("Rented")
                    .foregroundStyle(Color.yellow)
                    .fontWeight(.bold)
//                    .padding()
            }
        }
    }
}

#Preview {
    ItemRow(itemModel: ItemModel(name: "Some", pricePerHour: 100, state: .available, dateRegistrated: Date()))
}

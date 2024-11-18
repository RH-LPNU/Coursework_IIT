//
//  ItemManager.swift
//  EasyRent
//
//  Created by Roman Hural on 17.09.2024.
//

import Foundation
import FirebaseFirestore

/// Firestore Database Items Table Manager
final class ItemManager {
    /// Property that creates singleton pattern
    static let shared = ItemManager()
    private init() { }
    
    /// Property that contains reference to the Firestore Database Items Table
    private let itemsCollection = Firestore.firestore().collection("items")
    
    /// Function that creates reference to the specific item in the Items Table
    /// - Parameter itemId: unique item id
    /// - Returns: Reference to the specific item in the Items Table
    private func itemCollectionReference(itemId: String) -> DocumentReference {
        itemsCollection.document(itemId)
    }
    
    /// Function that creates new item in the Firestore Database Items Table
    /// - Parameter item: Item data model
    func createItem(_ item: ItemModel) async throws {
        try itemCollectionReference(itemId: item.id.uuidString).setData(from: item, merge: false)
    }
    
    /// Function that updates item information in the Firebase Firestore during or after rent
    /// - Parameters:
    ///   - itemId: Item unique id that should be updated
    ///   - state: Item state that should be updated
    ///   - rentedByUserWithId: Unique rentant id
    ///   - orderID: Unique order id
    ///   - hoursInRent: Number of hours in rent
    ///   - dateRent: The date, when item rent has been started
    ///   - dateReturn: The date, when item should have been returned from rent
    func updateItem(itemId: String, state: ItemState, rentedByUserWithId: String, orderID: String, hoursInRent: Int, dateRent: Date, dateReturn: Date) async throws {
        if state == .available {
            try await itemCollectionReference(itemId: itemId).updateData([ItemModel.CodingKeys.state.rawValue : state.rawValue,
                                                                          ItemModel.CodingKeys.rentedByUserWithId.rawValue : FieldValue.delete(),
                                                                          ItemModel.CodingKeys.orderID.rawValue : FieldValue.delete(),
                                                                          ItemModel.CodingKeys.hoursInRent.rawValue : FieldValue.delete(),
                                                                          ItemModel.CodingKeys.dateRent.rawValue : FieldValue.delete(),
                                                                          ItemModel.CodingKeys.dateReturn.rawValue : FieldValue.delete()
                                                                         ])
        } else if state == .rented {
            let data: [String: Any] = [
                ItemModel.CodingKeys.state.rawValue : state.rawValue,
                ItemModel.CodingKeys.rentedByUserWithId.rawValue : rentedByUserWithId,
                ItemModel.CodingKeys.orderID.rawValue : orderID,
                ItemModel.CodingKeys.hoursInRent.rawValue : hoursInRent,
                ItemModel.CodingKeys.dateRent.rawValue : dateRent,
                ItemModel.CodingKeys.dateReturn.rawValue : dateReturn,
            ]
            try await itemCollectionReference(itemId: itemId).updateData(data)
        }
    }
    
    /// Function that updates item information in the Firebase Firestore after editing
    /// - Parameters:
    ///   - itemId: Item unique id
    ///   - state: State of the item
    ///   - name: Name of the item
    ///   - pricePerHour: Item price per hour
    ///   - category: Item category
    ///   - imageURLString: Item url image in the String format
    func updateItemAfterEditing(itemId: String, state: ItemState, name: String, pricePerHour: Int, category: ItemCategory, imageURLString: String) async throws {
        let data: [String : Any] = [
            ItemModel.CodingKeys.name.rawValue : name,
            ItemModel.CodingKeys.pricePerHour.rawValue : pricePerHour,
            ItemModel.CodingKeys.category.rawValue : category.rawValue,
            ItemModel.CodingKeys.imageURLString.rawValue : imageURLString
        ]
        
        if state == .available {
            try await itemCollectionReference(itemId: itemId).updateData(data)
        }
    }
    
    /// Function that deletes item in the Firebase Firestore
    /// - Parameter item: Item data model that should be deleted
    func deleteItem(_ item: ItemModel) {
        itemCollectionReference(itemId: item.id.uuidString).delete()
    }
    
    /// Function that fetches items from Firebase Firestore from Items Table
    /// - Returns: Array of all items from Firestore Database Items Table
    func fetchItems() async throws -> [ItemModel] {
        let snapshot = try await itemsCollection.getDocuments()
        
        var items = [ItemModel]()
        for document in snapshot.documents {
            var item = try document.data(as: ItemModel.self)
            if let uuidFromString = UUID(uuidString: document.documentID) {
                item.id = uuidFromString
                items.append(item)
            }
        }
        
        return items
    }
}

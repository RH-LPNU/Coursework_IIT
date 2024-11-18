//
//  ProfileViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 21.09.2024.
//

import Foundation

/// Class that manages the business logic of the Profile Screen
@MainActor
class ProfileViewModel: ObservableObject {
    /// Property that contains signed in user
    @Published private(set) var user: DBUser? = nil
    /// Property that contains the array of the items list
    @Published private(set) var items: [ItemModel] = []
    
    /// Computed property to get count of available items in the items array
    var availableItemsNumber: Int {
        let allItems = items
        let availableItems = allItems.filter({ $0.state == .available })
        
        return availableItems.count
    }
    
    /// Computed property to get count of rented items in the items array
    var rentedItemsNumber: Int {
        let allItems = items
        let rentedlItems = allItems.filter({ $0.state == .rented })
        
        return rentedlItems.count
    }
    
    /// Function that loads information about signed in user from Firestore Database
    func loadCurrentUser() async throws {
       let authDataResult = try AuthentificationManager.shared.getAuthentificatedUser()
       self.user = try await UserManager.shared.getUser(withID: authDataResult.uid)
    }
    
    /// Function that retrives items list from Firestore Database and sets it to items array value
    func getAllItems() async throws {
        self.items = try await ItemManager.shared.fetchItems()
    }
    
    /// Function that converts Date to String format
    /// - Parameter date: Date to be converted to String format
    /// - Returns: String date format
    func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

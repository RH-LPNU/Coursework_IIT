//
//  OrdersListViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 21.09.2024.
//

import Foundation

/// Class that manages the business logic of the Rents Screen
@MainActor
class RentsListViewModel: ObservableObject {
    /// Property that contains signed in user
    @Published var user: DBUser? = nil
    /// Property that contains the array of the rents list
    @Published var rents: [Rent] = []
    /// Property that contains the entered text in the search bar
    @Published var searchedText: String = ""
    /// Property that contains the RentState status
    @Published var status: RentState = .inUse
    
    /// Computed property that filter the rents array by RentState status
    var filteredRents: [Rent] {
        
        let filterByStatus: [Rent]
        
        if status == .inUse {
            filterByStatus = self.rents.filter { $0.state == .inUse }
        } else {
            filterByStatus = self.rents.filter { $0.state == .finished }
        }
        if searchedText.isEmpty {
            return filterByStatus.sorted { $0.rentDate > $1.rentDate }
        } else {
            return filterByStatus.filter {
                $0.userId.localizedCaseInsensitiveContains(searchedText) ||
                $0.id.uuidString.localizedCaseInsensitiveContains(searchedText) ||
                $0.itemName.localizedCaseInsensitiveContains(searchedText)
            }
        }
    }
    
    /// Function that retrives rents list from Firestore Database and sets it to rents array value;
    /// Retrives all rents for admin user and own user rents for customer user
    func fetchRents() async throws {
        guard let user else { return }
        
        if user.isAdmin {
            self.rents = try await RentManager.shared.fetchAllRents()
        } else {
            self.rents = try await RentManager.shared.fetchUserRents(userId: user.userId)
        }
    }
    
    /// Function that loads information about signed in user from Firestore Database
    func loadCurrentUser() async throws {
       let authDataResult = try AuthentificationManager.shared.getAuthentificatedUser()
       self.user = try await UserManager.shared.getUser(withID: authDataResult.uid)
    }
    
    /// Function that converts Date to String format
    /// - Parameter date: Date to be converted to String format
    /// - Returns: String date format
    func convertDate(date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        guard let date else { return nil }
        
        return dateFormatter.string(from: date)
    }
}

//
//  UsersViewModel.swift
//  EasyRent
//
//  Created by Roman Hural on 25.10.2024.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [DBUser] = []
    
    func retriveAllUsers() async throws {
        self.users = try await UserManager.shared.fetchUsers()
    }
}

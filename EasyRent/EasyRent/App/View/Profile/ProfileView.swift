//
//  ProfileView.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// ProfileView Screen
struct ProfileView: View {
    /// Property that contains view model of the profile screen
    @StateObject private var viewModel = ProfileViewModel()
    /// Property that checks whether or not show AuthentificationView
    @Binding var showSignInView: Bool
    
    /// Describes the Profile Screen interface
    var body: some View {
        List {
            Section("User Info") {
                HStack(spacing: 10) {
                    Text("ID:")
                        .fontWeight(.bold)
                    Text("\(viewModel.user?.userId ?? "")")
                }
                HStack(spacing: 10) {
                    Text("Email:")
                        .fontWeight(.bold)
                    Text("\(viewModel.user?.email ?? "")")
                }
                HStack(spacing: 10) {
                    Text("First Name:")
                        .fontWeight(.bold)
                    Text("\(viewModel.user?.firstName ?? "")")
                }
                HStack(spacing: 10) {
                    Text("Last Name:")
                        .fontWeight(.bold)
                    Text("\(viewModel.user?.lastName ?? "")")
                }
                HStack(spacing: 10) {
                    Text("User Type:")
                        .fontWeight(.bold)
                    Text("\((viewModel.user?.isAdmin ?? false) ? "Administrator" : "Customer")")
                }
                HStack(spacing: 10) {
                    Text("Account Created:")
                        .fontWeight(.bold)
                    Text("\(viewModel.convertDate(date: viewModel.user?.dateCreated ?? Date()))")
                }
            }

            if viewModel.user?.isAdmin ?? false {
                Section("Items") {
                    HStack(spacing: 10) {
                        Text("Registrated:")
                            .fontWeight(.bold)
                        Text("\(viewModel.items.count) Item\(viewModel.items.count == 1 ? "" : "s")")
                    }
                    HStack(spacing: 10) {
                        Text("Available:")
                            .fontWeight(.bold)
                        Text("\(viewModel.availableItemsNumber) Item\(viewModel.availableItemsNumber == 1 ? "" : "s")")
                    }
                    HStack(spacing: 10) {
                        Text("Rented:")
                            .fontWeight(.bold)
                        Text("\(viewModel.rentedItemsNumber) Item\(viewModel.rentedItemsNumber == 1 ? "" : "s")")
                    }
                }
                
//                Section("Manage Users") {
//                    NavigationLink {
//                        UserListView()
//                    } label: {
//                        Text("Users")
//                    }
//                }
            }
            
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
            if viewModel.user?.isAdmin ?? false {
                try? await viewModel.getAllItems()
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

//
//  ItemsListView.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import Foundation
import SwiftUI

/// Items Screen
struct ItemsListView: View {
    /// Property that contains view model of the items screen
    @StateObject private var viewModel = ItemsViewModel()
    /// Property that checks whether AddItemFormView is presented
    @State private var isPresented: Bool = false
    /// Property that contains the name of the chosen category
    @State private var categoryName = "All"
    /// Property that contains the name sorting style of the items list
    @State private var sortedStyle = "Registration Date (Newest)"
    
    private let sortString = "Sorted By:"
    
    /// Describes the Items Screen interface
    var body: some View {
        VStack {
            HStack {
                Text("Category:")
                    .bold()
                Menu(categoryName) {
                    Button("All") {
                        viewModel.category = .all
                        categoryName = "All"
                    }
                    Button("Vehicles") {
                        viewModel.category = .vehicles
                        categoryName = "Vehicles"
                    }
                    Button("Camping") {
                        viewModel.category = .camping
                        categoryName = "Camping"
                    }
                    Button("Sport Inventory") {
                        viewModel.category = .sportInventory
                        categoryName = "Sport Inventory"
                    }
                    Button("Other") {
                        viewModel.category = .other
                        categoryName = "Other"
                    }
                }
            }
            HStack {
                Text(sortString)
                    .bold()
                Text(sortedStyle)
            }
            if !viewModel.isLoading {
                if !viewModel.filteredItems.isEmpty {
                    List(viewModel.filteredItems) { item in
                        NavigationLink(value: item) {
                            ItemRow(itemModel: item)
                        }
                        .accessibilityLabel(Text("You chose \(item.name) item. Double click to get detailed information"))
                    }
                } else {
                    EmptyView()
                }
            } else {
                ProgressView()
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getAllItems()
        }
        .navigationTitle(LocalizedStringKey("Items"))
        .navigationDestination(for: ItemModel.self) { ItemDetailView(viewModel: viewModel, item: $0, userEmail: "") }
        .searchable(text: $viewModel.searchText, prompt: LocalizedStringKey("Search Item..."))
        .refreshable {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getAllItems()
        }
        .sheet(isPresented: $isPresented) { AddItemFormView(viewModel: viewModel) }
        .listRowSpacing(10)
        .toolbar {
            if viewModel.user?.isAdmin ?? false {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $viewModel.availability) {
                        Text(LocalizedStringKey("Avalaible")).tag(ItemState.available)
                        Text(LocalizedStringKey("Rented")).tag(ItemState.rented)
                    }
                    .pickerStyle(.segmented).padding(20)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Text(LocalizedStringKey("Add Item"))
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Menu("Sort By") {
                    Button("Name Desc. Order") {
                        viewModel.sortedBy = .byNameDescending
                        sortedStyle = "Name (Desc. Order)"
                    }
                    Button("Name Asc. Order") {
                        viewModel.sortedBy = .byNameAscending
                        sortedStyle = "Name (Asc. Order)"
                    }
                    Button("Price (Lowest)") {
                        viewModel.sortedBy = .byPriceToHighest
                        sortedStyle = "Price (Lowest)"
                    }
                    Button("Price (Highest)") {
                        viewModel.sortedBy = .byPriceToLowest
                        sortedStyle = "Price (Highest)"
                    }
                    Button("Registration Date (Newest)") {
                        viewModel.sortedBy = .byRegistrationDateNewest
                        sortedStyle = "Registration Date (Newest)"
                    }
                    Button("Registration Date (Oldest)") {
                        viewModel.sortedBy = .byRegistrationDateOldest
                        sortedStyle = "Registration Date (Oldest)"
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemsListView()
    }
}

//
//  OrdersList.swift
//  EasyRent
//
//  Created by Roman Hural on 21.09.2024.
//

import SwiftUI

/// RentsListView Screen
struct RentsListView: View {
    /// Property that contains view model of the rents screen
    @StateObject var viewModel = RentsListViewModel()
    
    /// Describes the Rents Screen interface
    var body: some View {
        VStack {
            List(viewModel.filteredRents) { rent in
                Section("ID: \(rent.id.uuidString)") {
                    RentRow(itemName: rent.itemName,
                            price: rent.totalPrice,
                            hoursInRent: rent.hoursInRent,
                            rentDate: viewModel.convertDate(date: rent.rentDate) ?? "",
                            returnDate: viewModel.convertDate(date: rent.deadlineReturnDate) ?? "",
                            userID: rent.userId, actualReturnDate: viewModel.convertDate(date: rent.actualReturnDate))
                }
            }
            .navigationTitle(LocalizedStringKey("Rents"))
            .searchable(text: $viewModel.searchedText, prompt: LocalizedStringKey("Enter Rent ID, User ID Or Item Name..."))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $viewModel.status) {
                        Text(LocalizedStringKey("In Use")).tag(RentState.inUse)
                        Text(LocalizedStringKey("Finished")).tag(RentState.finished)
                    }
                    .pickerStyle(.segmented).padding(20)
                }
            }
            .refreshable { try? await viewModel.fetchRents() }
            .task {
                try? await viewModel.loadCurrentUser()
                try? await viewModel.fetchRents()
            }
        }
    }
}

#Preview {
    RentsListView()
}

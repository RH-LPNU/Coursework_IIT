//
//  ItemRentView.swift
//  EasyRent
//
//  Created by Roman Hural on 18.09.2024.
//

import SwiftUI

/// ItemRentView Screen
struct ItemRentView: View {
    /// Property that contains view model of the items screen
    @ObservedObject var viewModel: ItemsViewModel
    /// Property that dismisses the ItemRentView Screen
    @Environment(\.dismiss) private var dismiss
    /// Item data model
    @Binding var item: ItemModel
    //    @FocusState private var isFocused: Bool
    /// Property that defines what text field should be active
    @FocusState private var focusedField: FocusableField?
    /// Property that contains text fileds text of rentant user email
    @Binding var userEmail: String
    
    /// Describes the ItemRentView Screen interface
    var body: some View {
        NavigationStack {
            List {
                Section(LocalizedStringKey("Rented Item")) {
                    HStack(spacing: 10) {
                        Text("ID:").fontWeight(.bold)
                        Text("\(item.id.uuidString)")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Name:")).fontWeight(.bold)
                        Text("\(item.name)")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Price Per Hour:")).fontWeight(.bold)
                        Text("\(item.pricePerHour) UAH")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Hours In Rent:")).fontWeight(.bold)
                        TextField(LocalizedStringKey("Enter Number"), text: $viewModel.hoursInRent)
                            .focused($focusedField, equals: .hoursInRent)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Total Rent Price:")).fontWeight(.bold)
                        Text("\(viewModel.calculateTotalPrice(pricePerHour: item.pricePerHour)) UAH")
                    }
                }
                
                Section("Check Rentant Email") {
                    HStack {
                        Text("Email:")
                            .fontWeight(.bold)
                        TextField("Enter Rentant Email", text: $userEmail)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .userEmail)
                    }
                    HStack {
                        Text("Registrated:")
                            .fontWeight(.bold)
                        if let _ = viewModel.rentant {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                                .fontWeight(.bold)
                        } else {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.red)
                                .fontWeight(.bold)
                        }
                    }
                    VStack(alignment: .center) {
                        Button("Check Account Registration") {
                            Task {
                                let _ = try? await viewModel.fetchUserWithEmail(userEmail.lowercased())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                    .frame(maxWidth: .infinity)

                }
                
                Section(LocalizedStringKey("Rentant Info")) {
                    HStack(spacing: 10) {
                        Text("ID:")
                            .fontWeight(.bold)
                        Text("\(viewModel.rentant?.userId ?? "N/A")")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("First Name:"))
                            .fontWeight(.bold)
                        Text("\(viewModel.rentant?.firstName ?? "N/A")")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Last Name:"))
                            .fontWeight(.bold)
                        Text("\(viewModel.rentant?.lastName ?? "N/A")")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Email:"))
                            .fontWeight(.bold)
                        Text("\(viewModel.rentant?.email ?? "N/A")")
                    }
                }
                
                Section {
                    VStack(alignment: .center) {
                        Button(LocalizedStringKey("Confirm Rent")) {
                            item.state = .rented
                            item.hoursInRent = Int(viewModel.hoursInRent) ?? 0
                            item.orderID = UUID().uuidString
                            item.rentedByUserWithId = viewModel.rentant?.userId
                            Task {
//                                try? await viewModel.updateItem(itemId: item.id.uuidString, state: .rented)
                                try? await viewModel.updateItem(itemId: item.id.uuidString,
                                                                itemName: item.name,
                                                                pricePerHour: item.pricePerHour,
                                                                state: .rented, orderId: item.orderID!)
                            }
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear { focusFirstField() }
            .onSubmit { focusNextField() }
            .navigationTitle(LocalizedStringKey("Rent Details"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(LocalizedStringKey("Cancel"))
                    }
                }
            }
        }
    }
    
    /// Function that sets focusedField property to the first FocusableFields enum case
    private func focusFirstField() {
            focusedField = FocusableField.allCases.first
        }
    
    /// Function that updates the focusedField property
    private func focusNextField() {
        switch focusedField {
        case .hoursInRent:
            focusedField = .userEmail
        case .userEmail:
            focusedField = nil
        case .none:
            break
        }
    }
}


extension ItemRentView {
    /// Enum for focusable text fields
    enum FocusableField: Hashable, CaseIterable {
        case hoursInRent
        case userEmail
    }
}

#Preview {
    @State var item: ItemModel = ItemModel(name: "Bike", 
                                           pricePerHour: 100,
                                           state: .available,
                                           dateRegistrated: Date(),
                                           dateReturn: Date())
    @State var email: String = ""
    return ItemRentView(viewModel: ItemsViewModel(), item: $item, userEmail: $email)
}

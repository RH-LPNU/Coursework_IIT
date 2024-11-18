//
//  ItemDetailView.swift
//  EasyRent
//
//  Created by Roman Hural on 17.09.2024.
//

import SwiftUI

/// ItemDetailView Screen
struct ItemDetailView: View {
    /// Property that contains view model of the items screen
    @ObservedObject var viewModel: ItemsViewModel
    /// Property that checks whether ItemRentView is presented
    @State private var isPresented: Bool = false
    /// Property that checks whether EditItemView is presented
    @State private var editViewIsPresented: Bool = false
    /// Property that checks whether alert before deletion is presented
    @State private var alertIsPresented: Bool = false
    /// Item data model
    @State var item: ItemModel
    /// Property that contains rentant user email
    @State var userEmail: String
    
    /// Describes the ItemDetailView Screen interface
    var body: some View {
        VStack {
            if let urlString = item.imageURLString {
                if let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    } placeholder: {
                        ProgressView()
                    }
                }
            } else {
                Image(.default)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            List {
                Section(LocalizedStringKey("Item Info")) {
                    HStack(spacing: 10) {
                        Text("ID:").fontWeight(.bold)
                        Text("\(item.id)")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Name:")).fontWeight(.bold)
                        Text("\(item.name)")
                    }
                    
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Category:")).fontWeight(.bold)
                        Text(item.category?.categoryTitle() ?? "No Category")
                    }
                    
                    HStack(spacing: 10) {
                        Text("Price Per Hour:").fontWeight(.bold)
                        Text("\(item.pricePerHour) UAH")
                    }
                    HStack(spacing: 10) {
                        Text(LocalizedStringKey("Registration:")).fontWeight(.bold)
                        Text("\(viewModel.convertDate(date: item.dateRegistrated))")
                    }
                    HStack(spacing: 10) {
                        Text("State:").fontWeight(.bold)
                        Text("\(item.state == .available ? "Available" : "Rented")")
                    }
                }
                
                if item.state == .available {
                }
                
                if item.state == .available && viewModel.user?.isAdmin ?? false {
                    Section {
                        VStack(alignment: .center) {
                            Button(LocalizedStringKey("Make A Rent")) {
                                isPresented = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Section {
                        VStack(alignment: .center) {
                            Button("Delete Item") {
                                alertIsPresented = true
                            }
                            .foregroundStyle(Color.red)
                            .alert("Item Deletion",
                                   isPresented: $alertIsPresented) {
                                Button("Cancel", role: .cancel) {
                                    alertIsPresented = false
                                }
                                Button("Confirm", role: .none) {
                                    viewModel.deleteItem(item)
                                }
                            } message: {
                                Text("Are You Sure About Deleting The Item?")
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                if (viewModel.user?.isAdmin ?? true) && item.state == .rented {
                    Section(LocalizedStringKey("Rentant Information")) {
                        HStack(spacing: 10) {
                            Text("ID:").fontWeight(.bold)
                            Text("\(item.rentedByUserWithId ?? "N/A")")
                        }
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("First Name:")).fontWeight(.bold)
                            Text("\(viewModel.rentant?.firstName ?? "N/A")")
                        }
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("Last Name:")).fontWeight(.bold)
                            Text("\(viewModel.rentant?.lastName ?? "N/A")")
                        }
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("Email:")).fontWeight(.bold)
                            Text("\(viewModel.rentant?.email ?? "N/A")")
                        }
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("Rent Date:")).fontWeight(.bold)
                            Text("\(viewModel.convertDate(date: item.dateRent ?? Date()))")
                        }
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("Return Date:")).fontWeight(.bold)
                            Text("\(viewModel.convertDate(date: item.dateReturn ?? Date()))")
                        }
                        HStack(spacing: 10) {
                            Text("In Rent:").fontWeight(.bold)
                            Text("\(item.hoursInRent ?? 0) hours")
                        }
                        HStack(spacing: 10) {
                            Text("Total Price:").fontWeight(.bold)
                            Text("\(item.priceForRent ?? 0) UAH")
                        }
                    }
                                        
                    Section {
                        VStack(alignment: .center) {
                            Button(LocalizedStringKey("Returned From Rent")) {
                                item.state = .available
                                Task {
                                    try? await viewModel.updateItem(itemId: item.id.uuidString,
                                                                    itemName: item.name,
                                                                    pricePerHour: item.pricePerHour,
                                                                    state: .available, orderId: item.orderID!)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            ItemRentView(viewModel: viewModel, item: $item, userEmail: $userEmail)
        }
        .sheet(isPresented: $editViewIsPresented) {
            EditItemView(viewModel: viewModel, item: $item, isPresented: $editViewIsPresented)
        }
        .task {
            if item.state == .rented {
                guard let rentantID = item.rentedByUserWithId else { return }
                try? await viewModel.getUser(userID: rentantID)
            }
        }
        .toolbar {
            
            if item.state == .available && viewModel.user?.isAdmin ?? false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editViewIsPresented = true
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
        .navigationTitle(LocalizedStringKey("Details")).navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var userEmail: String = ""
    
    return ItemDetailView(viewModel: ItemsViewModel(),
                   item: ItemModel(name: "Car",
                                   pricePerHour: 500,
                                   state: .available,
                                   dateRegistrated: Date()), userEmail: "")
}

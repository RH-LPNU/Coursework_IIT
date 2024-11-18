//
//  AddItemForm.swift
//  EasyRent
//
//  Created by Roman Hural on 17.09.2024.
//

import SwiftUI
import PhotosUI

/// AddItemFormView Screen
struct AddItemFormView: View {
    /// Property that contains view model of the items screen
    @ObservedObject var viewModel: ItemsViewModel
    /// Property that contains the name of the chosen category
    @State private var categoryName: String = "Click To Choose Category"
    /// Property that contains selected image from PhotosUI
    @State private var selectedImage: Image = Image(.default)
    /// Property that defines PhotosPicker
    @State private var photosPickerItem: PhotosPickerItem?
    /// Property that contains chosen item category
    @State private var itemCategory: ItemCategory?
//    @State private var errorText = Text(EasyRentError.fieldsWithoutText.rawValue)
    /// Property that checks whether alert is presented
    @State private var isPresented = false
    /// Property that dismisses the AddItemFormView Screen
    @Environment(\.dismiss) private var dismiss
    
    /// Describes the AddItemFormView Screen interface
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                        PhotosPicker("Select a Photo",
                                     selection: $photosPickerItem,
                                     matching: .images)
                }
                .onChange(of: photosPickerItem, perform: { value in
                    Task {
                        let pickedImage = try await photosPickerItem?.loadTransferable(type: Image.self)
                        if let pickedImage {
                            selectedImage = pickedImage
                            itemCategory = viewModel.doImageClassPrediction(imageCVP: selectedImage.getUIImage()?.toCVPixelBuffer())
                            categoryName = itemCategory?.categoryTitle() ?? ""
                        }
                    }
                })

                TextField(LocalizedStringKey("Item Name"), text: $viewModel.newItemName)
                TextField(LocalizedStringKey("Item Price Per Hour"), text: $viewModel.newItemPrice)
                HStack {
                    Text("Category:")
                    Menu(categoryName) {
                        Button("Vehicles") {
                            categoryName = "Vehicles"
                            itemCategory = .vehicles
                        }
                        Button("Camping") {
                            categoryName = "Camping"
                            itemCategory = .camping
                        }
                        Button("Sport Inventory") {
                            categoryName = "Sport Inventory"
                            itemCategory = .sportInventory
                        }
                        Button("Other") {
                            categoryName = "Other"
                            itemCategory = .other
                        }
                    }
                }
                VStack(alignment: .center) {
                    Button(LocalizedStringKey("Create New Item")) {
                        do {
                            try viewModel.registerNewItem(itemCategory: itemCategory ?? .other, itemPhoto: selectedImage.getUIImage())
//                            isHidden = true
                            dismiss()
                        } catch {
//                            isHidden = false
                            isPresented = true
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(LocalizedStringKey("Register New Item"))
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
            .alert("Please, fill the name and price fields of the item", isPresented: $isPresented) {
                Button("Ok", role: .cancel) {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    AddItemFormView(viewModel: ItemsViewModel())
}

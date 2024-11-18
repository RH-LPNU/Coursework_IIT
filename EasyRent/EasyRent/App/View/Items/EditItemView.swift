//
//  EditItemView.swift
//  EasyRent
//
//  Created by Roman Hural on 22.09.2024.
//

import SwiftUI
import PhotosUI

/// EditItemView Screen
struct EditItemView: View {
    /// Property that defines text field to be active
    @FocusState private var isFocused: Bool
    /// Property that contains view model of the items screen
    @ObservedObject var viewModel: ItemsViewModel
    /// Item data model
    @Binding var item: ItemModel
    /// Property that defines whether or not EditItemView should be presented
    @Binding var isPresented: Bool
    /// Property that contains selected image from PhotosUI
    @State private var selectedImage: Image?
    /// Property that defines PhotosPicker
    @State private var photosPickerItem: PhotosPickerItem?
    
    /// Computed property that checks whether image from PhotosUI is selected
    private var isImageSelected: Bool {
        return selectedImage != nil
    }
    
    /// Describes the EditItemView Screen interface
    var body: some View {
        NavigationStack {
            List {
                Section("Item Information") {
                    HStack {
                        Text("ID:")
                            .fontWeight(.bold)
                        Text(item.id.uuidString)
                    }
                    HStack {
                        Text("Status:")
                            .fontWeight(.bold)
                        Text(item.state.rawValue.capitalized)
                    }
                }
                Section("Edit Fields") {
                    HStack {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else if let urlString = item.imageURLString {
                            if let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
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
                        
                            PhotosPicker("Change a Photo",
                                         selection: $photosPickerItem,
                                         matching: .images)
                    }
                    .onChange(of: photosPickerItem, perform: { value in
                        Task {
                            let pickedImage = try await photosPickerItem?.loadTransferable(type: Image.self)
                            if let pickedImage {
                                selectedImage = pickedImage
                                item.category = viewModel.doImageClassPrediction(imageCVP: pickedImage.getUIImage()?.toCVPixelBuffer())
//                                categoryName = itemCategory?.categoryTitle() ?? ""
                            }
                        }
                    })
                    
                    HStack {
                        Text("Name:")
                            .fontWeight(.bold)
                        TextField("Enter New Name", text: $item.name)
                            .textFieldStyle(.roundedBorder)
                            .focused($isFocused)
                    }
                    HStack {
                        Text("Price:")
                            .fontWeight(.bold)
                        TextField("Enter New Price", value: $item.pricePerHour, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Category:")
                            .fontWeight(.bold)
                        Menu(item.category?.categoryTitle() ?? "No Category") {
                            Button("Vehicles") {
                                item.category = .vehicles
                            }
                            Button("Camping") {
                                item.category = .camping
                            }
                            Button("Sport Inventory") {
                                item.category = .sportInventory
                            }
                            Button("Other") {
                                item.category = .other
                            }
                        }
                    }
                }
                Section {
                    VStack(alignment: .center) {
                        Button {
                            if selectedImage == nil {
                                
                            }
                            Task {
                                try? await viewModel.updateItemAfterEditing(item: item, selectedImage: selectedImage?.getUIImage(), isNewImageSelected: isImageSelected)
                            }
                            isPresented = false
                        } label: {
                            Text("Confirm Changes")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Edit Item").navigationBarTitleDisplayMode(.inline)
            .onAppear { 
                isFocused = true
                
            }
        }
    }
    
    func categoryTitle() -> String {
        guard let category = item.category else { return "No Category" }
        
        switch category {
        case .all:
            return ""
        case .sportInventory:
            return "Sport Inventory"
        case .camping:
            return "Camping"
        case .vehicles:
            return "Vehicles"
        case .other:
            return "Other"
        }
    }
}

//#Preview {
//    EditItemView(item: <#Binding<ItemModel>#>)
//}

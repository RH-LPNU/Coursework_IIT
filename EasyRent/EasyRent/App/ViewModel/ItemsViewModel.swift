//
//  ItemsViewModels.swift
//  EasyRent
//
//  Created by Roman Hural on 16.09.2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import CoreML

/// Class that manages the business logic of the Items Screen
@MainActor
class ItemsViewModel: ObservableObject {
    /// Property that contains signed in user
    @Published private(set) var user: DBUser? = nil
    /// Property that contains rentant information
    @Published private(set) var rentant: DBUser? = nil
    /// Property that contains the array of the items list
    @Published private(set) var items: [ItemModel] = []
    /// Property that contains the entered text in the search bar
    @Published var searchText = ""
    /// Property that contains the ItemState status
    @Published var availability: ItemState = .available
    /// Property that checks whether items list has already downloaded from the Firestore Database
    @Published var isLoading = false
    /// Property that contains the item name during the item registration
    @Published var newItemName = ""
    /// Property that contains the item price during the item registration
    @Published var newItemPrice = ""
    /// Property that contains hours in rent during rent process
    @Published var hoursInRent = "1"
    /// Property that defines the sorted item list style
    @Published var sortedBy: SortedStyle = .byRegistrationDateNewest
    /// Property that defines the filter for item list by category
    @Published var category: ItemCategory = .all
    
    /// Machine Learning model that used for image classification
    var imageClassificationModel: EasyRentMLModel?
    
    var totalPrice: Int {
        Int(hoursInRent) ?? 0
    }
    
    /// Computed property that filter the items array by availability and chosen category
    var filteredItems: [ItemModel] {
        let filteredByAvailability: [ItemModel] = filterByAvailability(state: availability)
        let filterByCategory: [ItemModel] = filterByCategory(items: filteredByAvailability)
        
        if !searchText.isEmpty {
            let searchItemsResult = filterByCategory.filter { item in
                let stringPricePerHour = String(item.pricePerHour)
                
                return stringPricePerHour.localizedCaseInsensitiveContains(searchText) ||
                       item.name.localizedStandardContains(searchText)
            }
            
            return sortedBy(option: sortedBy, items: searchItemsResult)
        } else {
            return sortedBy(option: sortedBy, items: filterByCategory)
        }
    }
    
    /// Loads CoreML model
    init() {
        do {
            imageClassificationModel = try EasyRentMLModel(configuration: MLModelConfiguration())
        } catch {
            print(error)
        }
    }
    
    /// Function that does category prediction based on the imageCVP parameter using CoreML model
    /// - Parameter imageCVP: UIImage in CVPixelBuffer format
    /// - Returns: Item catefory based on CoreML prediction
    func doImageClassPrediction(imageCVP: CVPixelBuffer?) -> ItemCategory {
        guard let imageCVP else { return .other }
        
        do {
            let result = try? imageClassificationModel?.prediction(image: imageCVP)

            guard let result else { return .other }
            switch result.target {
            case "Vehicles":
                return .vehicles
            case "Sport Inventory":
                return .sportInventory
            case "Camping":
                return .camping
            default:
                return .other
            }
        }
    }
    
    
    /// Function that performs calculations in order to get total rent price
    /// - Parameter pricePerHour: Numbers of hours in rent
    /// - Returns: Total rent price
    func calculateTotalPrice(pricePerHour: Int) -> Int {
        pricePerHour * (Int(hoursInRent) ?? 0)
    }
    
    /// Function that retrives items list from Firestore Database and sets it to items array value
    func getAllItems() async throws {
        self.items = try await ItemManager.shared.fetchItems()
    }
    
    /// Function that updates the item state and its information during or after the rent period
    /// - Parameters:
    ///   - itemId: Unique id of the rented item
    ///   - itemName: Name of the rented item
    ///   - pricePerHour: Item price per hour for rent
    ///   - state: Item state: available or rented
    ///   - orderId: Unique id of the rent order
    func updateItem(itemId: String, itemName: String, pricePerHour: Int, state: ItemState, orderId: String) async throws {
        guard let rentant, let hoursInRent = Int(hoursInRent) else { return }
        
        let startTime = Date()
        let endTime = Calendar.current.date(byAdding: .hour, value: hoursInRent, to: startTime) ?? Date()
        try await ItemManager.shared.updateItem(itemId: itemId,
                                                state: state,
                                                rentedByUserWithId: rentant.userId,
                                                orderID: orderId,
                                                hoursInRent: hoursInRent,
                                                dateRent: startTime,
                                                dateReturn: endTime)
        if state == .rented {
            let newRent = Rent(state: .inUse,
                               userId: rentant.userId,
                               itemId: itemId,
                               itemName: itemName,
                               pricePerHour: pricePerHour,
                               rentDate: startTime,
                               deadlineReturnDate: endTime,
                               hoursInRent: hoursInRent,
                               totalPrice: calculateTotalPrice(pricePerHour: pricePerHour))
            try await RentManager.shared.createRent(newRent, rentId: orderId)
        } else if state == .available {
            try await RentManager.shared.updateRentFor(rentID: orderId, status: .finished, actualReturnDate: Date())
        }
        
        self.hoursInRent = "1"
        try await getUser(userID: rentant.userId)
    }
    
    
    /// Function that deletes the item from the Firestore Database
    /// - Parameter item: Item for deletion process
    func deleteItem(_ item: ItemModel) {
        ItemManager.shared.deleteItem(item)
        Task {
            try? await FirebaseStorage.shared.deleteImageFor(urlString: item.imageURLString)
        }
    }
    
    /// Function that loads information about signed in user from Firestore Database
    func loadCurrentUser() async throws {
        isLoading = true
        
        let authDataResult = try AuthentificationManager.shared.getAuthentificatedUser()
        self.user = try await UserManager.shared.getUser(withID: authDataResult.uid)
        
        isLoading = false
    }
    
    /// Function that loads information about rentant from Firestore Database
    /// - Parameter userID: Unique rentant id
    func getUser(userID: String) async throws {
        self.rentant = try await UserManager.shared.getUser(withID: userID)
    }
    
    /// Function that registers new item
    /// - Parameters:
    ///   - itemCategory: Category of the new item
    ///   - itemPhoto: Image of the new item
    func registerNewItem(itemCategory: ItemCategory, itemPhoto: UIImage?) throws {
        guard !newItemName.isEmpty || !newItemPrice.isEmpty else { throw EasyRentError.fieldsWithoutText }
        var itemURLString: String?
        

        uploadImage(selectedImage: itemPhoto) { [weak self] urlString in
            guard let self else { return }
            
            itemURLString = urlString
            
            let newItem = ItemModel(name: newItemName,
                                    pricePerHour: Int(newItemPrice) ?? 0,
                                    state: .available,
                                    dateRegistrated: Date(),
                                    category: itemCategory,
                                    imageURLString: itemURLString)
            
            Task {
                try await ItemManager.shared.createItem(newItem)
                self.items.append(newItem)
            }
            
            newItemName = ""
            newItemPrice = ""
        }
    }
    
    /// Function that updates item information after the editing process
    /// - Parameters:
    ///   - item: Edited item
    ///   - selectedImage: New image selected from PhotosUI
    ///   - isNewImageSelected: Checks whether new image was selected
    func updateItemAfterEditing(item: ItemModel, selectedImage: UIImage?, isNewImageSelected: Bool) async throws {
        if isNewImageSelected {
            try await FirebaseStorage.shared.deleteImageFor(urlString: item.imageURLString)
            uploadImage(selectedImage: selectedImage) { url in
                Task {
                    try await ItemManager.shared.updateItemAfterEditing(itemId: item.id.uuidString,
                                                                        state: item.state,
                                                                        name: item.name,
                                                                        pricePerHour: item.pricePerHour,
                                                                        category: item.category ?? .other,
                                                                        imageURLString: url!)
                }
            }
        } else {
            try await ItemManager.shared.updateItemAfterEditing(itemId: item.id.uuidString,
                                                                state: item.state,
                                                                name: item.name,
                                                                pricePerHour: item.pricePerHour,
                                                                category: item.category ?? .other,
                                                                imageURLString: item.imageURLString!)
        }
    }
    
    /// Function that converts Date to String format
    /// - Parameter date: Date to be converted to String format
    /// - Returns: String date format
    func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    /// Retrives the rentant information for ItemDetailView
    /// - Parameter email: rentant email
    /// - Returns: Rentant User model
    func fetchUserWithEmail(_ email: String) async throws -> DBUser? {
        let fetchedUser = try await UserManager.shared.fetchUserWithEmail(email)
        self.rentant = fetchedUser
        
        return fetchedUser
    }
}

extension ItemsViewModel {
    /// Function that filters items array by its availability
    /// - Parameter state: Item state
    /// - Returns: Array of filtered items array
    func filterByAvailability(state: ItemState) -> [ItemModel] {
        switch state {
        case .available:
            return items.filter { $0.state == .available }
        case .rented:
            return items.filter { $0.state == .rented }
        }
    }
}

extension ItemsViewModel {
    /// Function that sorts items array based on the SortedStyle option
    /// - Parameters:
    ///   - option: SortedStyle option
    ///   - items: Items array that will be sorted
    /// - Returns: Sorted items array
    func sortedBy(option: SortedStyle, items: [ItemModel]) -> [ItemModel] {
        switch option {
        case .byRegistrationDateNewest:
            items.sorted { $0.dateRegistrated > $1.dateRegistrated }
        case .byNameDescending:
            items.sorted { $0.name > $1.name }
        case .byPriceToLowest:
            items.sorted { $0.pricePerHour > $1.pricePerHour }
        case .byRegistrationDateOldest:
            items.sorted { $0.dateRegistrated < $1.dateRegistrated }
        case .byNameAscending:
            items.sorted { $0.name < $1.name }
        case .byPriceToHighest:
            items.sorted { $0.pricePerHour < $1.pricePerHour }
        }
    }
}

extension ItemsViewModel {
    /// Function that filters items array by chosen category
    /// - Parameter items: Items array that will be filtered by the chosen category
    /// - Returns: Filtered items array
    func filterByCategory(items: [ItemModel]) -> [ItemModel] {
        switch category {
        case .all:
            items
        case .sportInventory:
            items.filter { $0.category == .sportInventory }
        case .camping:
            items.filter { $0.category == .camping }
        case .vehicles:
            items.filter { $0.category == .vehicles }
        case .other:
            items.filter { $0.category == .other }
        }
    }
}

extension ItemsViewModel {
    /// Function that uploads an image to Firebase Storage
    /// - Parameters:
    ///   - selectedImage: UIImage that will be uploaded
    ///   - completion: Completion handler to get the uploaded image link
    func uploadImage(selectedImage: UIImage?, completion: @escaping (String?) -> Void) {
        guard let selectedImage = selectedImage else {
            completion(nil)
            return
        }
        
        // Convert UIImage to Data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        // Reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        // Upload image data
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let url = url {
                    // Return the image URL via the completion handler
                    completion(url.absoluteString)
                } else {
                    completion(nil)
                }
            }
        }
    }
}

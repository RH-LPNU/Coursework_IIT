//
//  UserListView.swift
//  EasyRent
//
//  Created by Roman Hural on 25.10.2024.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        List(viewModel.users) { user in
            HStack {
                VStack {
                    
                    Text(user.firstName)
                    Text(user.lastName)
                }
                VStack {
                    Text(user.isAdmin ? "Administrator" : "Customer")
                    Button(user.isAdmin ? "Remove Admin Rights" : "Give Admin Rights") {
                        
                    }
                }
            }
        }
        .task { try? await viewModel.retriveAllUsers() }
    }
}

#Preview {
    UserListView()
}

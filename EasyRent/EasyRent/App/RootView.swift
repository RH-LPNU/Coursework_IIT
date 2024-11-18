//
//  RootView.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// View that describes the general interface structure of the application
struct RootView: View {
    /// When the value is false the user see authentification page
    @State private var showSignInView: Bool = false
    /// Changes the content shown on the screen
    @State private var selectedIndex: Int = 0
    
    /// Describes the general interface. Has onAppear property to check if user is logged in and fullScreenCover to show or hide authentification screen
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack() {
                ItemsListView()
            }
            .tabItem {
                Text(LocalizedStringKey("Items"))
                Image(systemName: "house.fill")
                    .renderingMode(.template)
            }
            .tag(0)
            
            NavigationStack() {
                RentsListView()
            }
            .tabItem {
                Text(LocalizedStringKey("Rents"))
                Image(systemName: "info.circle")
            }
            .tag(1)
            
            NavigationStack() {
                ProfileView(showSignInView: $showSignInView)
                    .navigationTitle(LocalizedStringKey("Profile"))
            }
            .tabItem {
                Label(LocalizedStringKey("Profile"), systemImage: "person.fill")
            }
            .tag(2)
        }
        .onAppear {
            let user = try? AuthentificationManager.shared.getAuthentificatedUser()
            self.showSignInView = user == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthentificationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}

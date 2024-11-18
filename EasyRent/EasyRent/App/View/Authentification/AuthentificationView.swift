//
//  AuthentificationView.swift
//  EasyRent
//
//  Created by Roman Hural on 14.09.2024.
//

import SwiftUI

/// Authentification Screen
struct AuthentificationView: View {
    
    /// Property to show or hide Authentification Screen
    @Binding var showSignInView: Bool
    
    /// Describes the Authentification Screen interface
    var body: some View {
        VStack {
            NavigationLink {
                SignUpWithEmailView(showSignInView: $showSignInView)
            } label: {
                Text(LocalizedStringKey("Sign Up With Email"))
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            .padding()
            
            HStack {
                Text(LocalizedStringKey("Already have an account?"))
                NavigationLink {
                    SignInWithEmailView(showSignInView: $showSignInView)
                } label: {
                    Text(LocalizedStringKey("Sign In"))
                }
                
            }
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Sign Up"))
    }
}

#Preview {
    NavigationStack {
        AuthentificationView(showSignInView: .constant(false))
    }
}

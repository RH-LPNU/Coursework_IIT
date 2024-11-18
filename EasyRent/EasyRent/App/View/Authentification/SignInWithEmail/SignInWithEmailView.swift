//
//  SignInEmailView.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// Sign In Screen
struct SignInWithEmailView: View {
    
    /// Property that contains view model of the sign up screen
    @StateObject private var viewModel = SignInWithEmailViewModel()
    /// Property that takes its state to AuthentificationView in order to know whether or not show Authentification Screen
    @Binding var showSignInView: Bool
    /// Property that defines what text field should be active
    @FocusState private var focusedField: FocusableFields?
    
    /// Describes the Sign In Screen interface
    var body: some View {
        VStack {
            TextField(LocalizedStringKey("Email"), text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .focused($focusedField, equals: .email)
            
            SecureField(LocalizedStringKey("Password"), text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .focused($focusedField, equals: .password)
            
            Button {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(LocalizedStringKey("Sign In"))
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            
            Spacer()
        }
        .onAppear { focusFirstField() }
        .onSubmit { focusNextField() }
        .padding()
        .navigationTitle(LocalizedStringKey("Sign In With Email"))
    }
    
    /// Function that sets focusedField property to the first FocusableFields enum case
    private func focusFirstField() {
            focusedField = FocusableFields.allCases.first
        }
    
    /// Function that updates the focusedField property
    private func focusNextField() {
        switch focusedField {
        case .email:
            focusedField = .password
        case .password:
            focusedField = nil
        case .none:
            break
        }
    }
    
}

extension SignInWithEmailView {
    /// Enum for focusable text fields
    enum FocusableFields: Hashable, CaseIterable {
        case email
        case password
    }
}

#Preview {
    NavigationStack {
        SignInWithEmailView(showSignInView: .constant(false))
    }
}

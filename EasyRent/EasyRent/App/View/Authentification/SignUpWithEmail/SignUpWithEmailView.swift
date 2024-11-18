//
//  SignUpWithEmail.swift
//  EasyRent
//
//  Created by Roman Hural on 15.09.2024.
//

import SwiftUI

/// Sign Up Screen
struct SignUpWithEmailView: View {
    
    /// Property that contains view model of the sign up screen
    @StateObject private var viewModel = SignUpWithEmailViewModel()
    /// Property that takes its state to AuthentificationView in order to know whether or not show Authentification Screen
    @Binding var showSignInView: Bool
    /// Property that defines what text field should be active
    @FocusState private var focusedField: FocusableFields?
    
    /// Describes the Sign Up Screen interface
    var body: some View {
        VStack {
            TextField(LocalizedStringKey("First Name"), text: $viewModel.firstName)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .focused($focusedField, equals: .firstName)
            
            TextField(LocalizedStringKey("Last Name"), text: $viewModel.lastName)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .focused($focusedField, equals: .lastName)
            
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
                        try await viewModel.signUp()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(LocalizedStringKey("Sign Up"))
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(LocalizedStringKey("Sign Up With Email"))
        .onAppear { focusFirstField() }
        .onSubmit { focusNextField() }
    }
    
    /// Function that sets focusedField property to the first FocusableFields enum case
    private func focusFirstField() {
            focusedField = FocusableFields.allCases.first
        }
    
    /// Function that updates the focusedField property
    private func focusNextField() {
        switch focusedField {
        case .firstName:
            focusedField = .lastName
        case .lastName:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = nil
        case .none:
            break
        }
    }
}

extension SignUpWithEmailView {
    /// Enum for focusable text fields
    enum FocusableFields: Hashable, CaseIterable {
        case firstName
        case lastName
        case email
        case password
    }
}

#Preview {
    NavigationStack {
        SignUpWithEmailView(showSignInView: .constant(false))
    }
}

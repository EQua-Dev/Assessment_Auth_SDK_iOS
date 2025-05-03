//
//  AuthView.swift
//  AuthSDK
//
//  Created by Richard Uzor on 03/05/2025.
//
import SwiftUI

public struct AuthView: View {
    let config: AuthConfig
    let onSubmit: (UserData) -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var errorMessage: String?
    
    public init(config: AuthConfig, onSubmit: @escaping (UserData) -> Void) {
        self.config = config
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Group {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                if config.showUsername {
                    TextField("Username", text: $username)
                }
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .foregroundColor(config.textColor)
            .font(config.font)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: handleSubmit) {
                Text(config.submitButtonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(config.primaryColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(config.backgroundColor.ignoresSafeArea())
    }
    
    private func handleSubmit() {
        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
        } else if password.count < 8 {
            errorMessage = "Password must be at least 8 characters"
        } else {
            errorMessage = nil
            let user = UserData(
                email: email,
                password: password,
                username: config.showUsername ? username : nil,
                firstName: firstName,
                lastName: lastName
            )
            SecureStorageHelper.store(user: user)
            onSubmit(user)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}


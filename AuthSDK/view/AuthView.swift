import SwiftUI

public struct AuthView: View {
    let config: AuthConfig
    let onSubmit: (UserData) -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var usernameError: String?
    
    @State private var showPassword = false
    
    public init(config: AuthConfig, onSubmit: @escaping (UserData) -> Void) {
        self.config = config
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Email Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Email").font(.headline).foregroundColor(config.textColor)
                TextField("Enter your email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                if let error = emailError {
                    Text(error).font(.footnote).foregroundColor(.red)
                }
            }
            
            // Password Field with toggle
            VStack(alignment: .leading, spacing: 4) {
                Text("Password").font(.headline).foregroundColor(config.textColor)
                HStack {
                    Group {
                        if showPassword {
                            TextField("Minimum 8 characters", text: $password)
                        } else {
                            SecureField("Minimum 8 characters", text: $password)
                        }
                    }
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                if let error = passwordError {
                    Text(error).font(.footnote).foregroundColor(.red)
                }
            }
            
            // Username Field (if applicable)
            if config.showUsername {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Username").font(.headline).foregroundColor(config.textColor)
                    TextField("No spaces or special characters", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    if let error = usernameError {
                        Text(error).font(.footnote).foregroundColor(.red)
                    }
                }
            }
            
            // First Name
            VStack(alignment: .leading, spacing: 4) {
                Text("First Name").font(.headline).foregroundColor(config.textColor)
                TextField("Enter your first name", text: $firstName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            
            // Last Name
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Name").font(.headline).foregroundColor(config.textColor)
                TextField("Enter your last name", text: $lastName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            
            // Submit Button
            Button(action: handleSubmit) {
                Text(config.submitButtonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(config.primaryColor)
                    .cornerRadius(8)
            }
        }
        .font(config.font)
        .foregroundColor(config.textColor)
        .padding()
        .background(config.backgroundColor.ignoresSafeArea())
    }
    
    private func handleSubmit() {
        // Reset errors
        emailError = nil
        passwordError = nil
        usernameError = nil
        
        var hasError = false
        
        if !isValidEmail(email) {
            emailError = "Invalid email format"
            hasError = true
        }
        
        if password.count < 8 {
            passwordError = "Password must be at least 8 characters"
            hasError = true
        }
        
        if config.showUsername && !isValidUsername(username) {
            usernameError = "No spaces or special characters allowed"
            hasError = true
        }
        
        if !hasError {
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

    private func isValidUsername(_ username: String) -> Bool {
        let regex = "^[a-zA-Z0-9_]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username)
    }
}

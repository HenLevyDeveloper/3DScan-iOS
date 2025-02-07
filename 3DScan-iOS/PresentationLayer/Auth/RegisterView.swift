//
//  RegisterView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordMismatch = false
    @FocusState private var focusedField: Field? // Track current field
    @Environment(\.dismiss) var dismiss

    // Enum to track focused field
    enum Field {
        case name, email, password, confirmPassword
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundGradient()

                VStack(spacing: 20) {
                    AppTitleIcon(iconSystemName: "person.crop.circle.badge.plus", title: "Create an Account")
                    .padding(.bottom, 30)
                    .onTapGesture {
                        focusedField = nil
                    }
                    
                    // Input Fields (Now Supports Next Keyboard Navigation)
                    VStack(spacing: 15) {
                        TextField("Full Name", text: $name)
                            .textFieldStyle()
                            .focused($focusedField, equals: .name)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email } // Move to Email

                        TextField("Email", text: $email)
                            .textFieldStyle()
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password } // Move to Password

                        SecureField("Password", text: $password)
                            .textFieldStyle()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .confirmPassword } // Move to Confirm Password

                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle()
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.done)
                            .onSubmit { focusedField = nil } // Dismiss Keyboard

                        // Password Mismatch Warning
                        if showPasswordMismatch {
                            Text("Passwords do not match")
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 30)
                    .onTapGesture {
                        focusedField = nil  // Dismiss keyboard when tapping outside
                    }

                    // Register Button
                    Button(action: {
                        if password == confirmPassword {
                            Task {
                                await authViewModel.register(name: name, email: email, password: password)
                                if authViewModel.isAuthenticated {
                                    dismiss() // Close the view after successful registration
                                }
                            }
                        } else {
                            showPasswordMismatch = true
                        }
                    }) {
                        AppButtonText("Register", backgroundColor: .darkGray)
                    }
                    .padding(.horizontal, 30)

                    // Error Message
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }

                    // Already Have an Account? Go Back to Login
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Already have an account? **Login**")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.top, 20)
                .onTapGesture {
                    focusedField = nil  // Dismiss keyboard when tapping outside
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(authViewModel: .create())
}

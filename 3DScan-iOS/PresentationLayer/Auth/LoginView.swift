//
//  LoginView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundGradient()
                
                ScrollView {
                    VStack(spacing: 20) {
                        AppTitleIcon(iconSystemName: "cube", title: "Gero 3D")
                            .padding(.bottom, 30)
                        
                        // Input Fields
                        VStack(spacing: 15) {
                            TextField("Email", text: $email)
                                .textFieldStyle()
                                .textInputAutocapitalization(.never)
                                .textContentType(.oneTimeCode)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle()
                                .textContentType(.oneTimeCode)
                        }
                        .padding(.horizontal, 30)
                        
                        if authViewModel.isLoggingIn {
                            ProgressView()
                        } else {
                            // Login Button
                            Button(action: {
                                Task {
                                    await authViewModel.login(email: email, password: password)
                                }
                            }) {
                                AppButtonText("Login")
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        // Error Message
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                        
                        // Register Navigation (Push)
                        NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                            Text("Don't have an account? **Register**")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.top, 50)
                }
            }
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    LoginView(authViewModel: .create())
}

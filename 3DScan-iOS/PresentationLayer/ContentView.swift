//
//  ContentView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel.create()

    var body: some View {
//        if authViewModel.isAuthenticated {
//            MainTabView()
//        } else {
//            LoginView(authViewModel: authViewModel)
//        }
        MainTabView()
    }
}


#Preview {
    ContentView()
}

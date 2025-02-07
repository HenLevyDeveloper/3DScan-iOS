//
//  MainTabView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: .create()).tabItem {
                Label("Home", systemImage: "house")
            }
            ScanView().tabItem {
                Label("Scan", systemImage: "camera")
            }
            ProfileView().tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile")
    }
}

#Preview {
    MainTabView()
}

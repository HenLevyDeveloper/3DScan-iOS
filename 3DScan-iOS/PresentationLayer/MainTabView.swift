//
//  MainTabView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.bgGray
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.lightBlue
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.lightBlue]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            HomeView(viewModel: .create()).tabItem {
                Label("Solutions", systemImage: "apple.meditate")
            }
            ScanIntroView().tabItem {
                Label("Scan", systemImage: "viewfinder")
            }
            ProfileView().tabItem {
                Label("Me", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainTabView()
}

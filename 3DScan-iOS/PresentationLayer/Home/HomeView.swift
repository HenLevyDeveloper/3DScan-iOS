//
//  HomeView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.solutions, id: \.id) { solution in
                        ListItemView(image: solution.image,
                                     title: solution.name,
                                     size: .init(width: UIScreen.main.bounds.width - 32, height: 160))
                    }
                }
            }
            .navigationTitle("Select Your Product Solution")
            .accentColor(.primary)
            .task {
                await viewModel.fetchSolutions()
            }
        }
    }
}


#Preview {
    HomeView(viewModel: HomeViewModel.create())
}

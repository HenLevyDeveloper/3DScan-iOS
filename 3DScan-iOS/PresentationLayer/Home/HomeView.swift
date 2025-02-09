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
            ScrollView {
                VStack {
                    // Body Parts Section
                    BodyPartsSectionView(bodyParts: viewModel.bodyParts)
                    
                    // Solutions Paging Section
                    SolutionsPagingSectionView(solutions: viewModel.solutions)
                    
                    // Educational Section
                    EducationalSectionView()
                    
                    Spacer(minLength: 16)
                }
                .task {
                    await viewModel.fetchSolutions()
                    await viewModel.fetchBodyParts()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Gero3DLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
            }
        }
    }
    
}


// MARK: - Body Parts Section
struct BodyPartsSectionView: View {
    let bodyParts: [BodyPart]
    
    private let size: CGSize = .init(width: 120, height: 100)
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("I need a solution for my..")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(bodyParts, id: \.id) { bodyPart in
                        NavigationLink(destination: DetailView(image: bodyPart.image, title: bodyPart.name, description: "", contentMode: .fill)) {
                            VStack(spacing: 8) {
                                AsyncImage(url: URL(string: bodyPart.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: size.width, height: size.height)
                                        .cornerRadius(cornerRadius)
                                        .clipped()
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: size.width, height: size.height)
                                        .cornerRadius(cornerRadius)
                                }
                                .frame(width: size.width, height: size.height)
                                .cornerRadius(cornerRadius)
                                
                                Text(bodyPart.name.capitalized)
                                    .font(.headline)
                                    .accentColor(.darkGray)
                                    .lineLimit(1)
                            }
                            .frame(width: size.width)
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }
}


// MARK: - Solutions Horizontal Paging Section
struct SolutionsPagingSectionView: View {
    let solutions: [ProductSolution]
    
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Product Solutions")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            // Solutions Horizontal Paging
            TabView(selection: $currentPage) {
                ForEach(solutions.indices, id: \.self) { index in
                    ProductSolutionItemView(productSolution: solutions[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            
            // Custom Page Dots
            HStack(spacing: 8) {
                ForEach(0..<solutions.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.metal : Color.gray.opacity(0.5))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Solution Item View
struct ProductSolutionItemView: View {
    let productSolution: ProductSolution
    private let size = CGSize(width: UIScreen.main.bounds.width - 32, height: 250)

    var body: some View {
        NavigationLink(destination: DetailView(image: productSolution.image, title: productSolution.name, description: productSolution.description, contentMode: .fit)) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: productSolution.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: size.height - 24)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.bgGray)
                        .frame(height: size.height)
                        .cornerRadius(10)
                }
                .frame(width: size.width, height: size.height)
                .background(Color.bgGray)

                Text(productSolution.name.capitalized)
                    .lineLimit(2)
                    .frame(minWidth: size.width - 32)
                    .font(.headline)
                    .accentColor(.darkGray)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: size.width)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 4)
            .padding(.horizontal, 20)
        }
    }
}


// MARK: - Educational Section View
struct EducationalSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Did You Know?")
                .font(.title2)
                .bold()
                .padding(.leading)
            
            HStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)
                
                Text("3D scanning can improve the precision of prosthetics and orthopedic solutions, ensuring a perfect fit for every patient.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 4)
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel.create())
}

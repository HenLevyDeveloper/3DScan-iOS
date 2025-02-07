//
//  DetailView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI

struct DetailView: View {
    let image: String
    let title: String
    let description: String
    let contentMode: ContentMode
    
    @State private var showScanScreen = false
    private let imageHeight: CGFloat = 250
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Image
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(height: imageHeight)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: imageHeight)
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.bgGray)
                
                // Title
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                    Divider()

                // Description
                Text(description.isEmpty ? "Easily scan your body part in 3D using your device's camera. Ensure good lighting and follow the instructions for the best results." : description)
                    .font(.body)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                // Scan Button
                Button {
                    showScanScreen = true
                } label: {
                    AppButtonText("Proceed to Scan")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("\(title) Details")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showScanScreen) {
                ScannerView()
            }
        }
    }
}

#Preview {
    DetailView(image: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Nadgarstek_%28ubt%29.jpeg",
               title: "Some Title",
               description: "",
               contentMode: .fill)
}

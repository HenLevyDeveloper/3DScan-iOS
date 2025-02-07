//
//  ListItemView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI

struct ListItemView: View {
    let image: String
    let title: String
    let size: CGSize
    
    private let horizontalPadding: CGFloat = 32
    
    var body: some View {
//        NavigationLink(destination: InfoView(id: id)) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: size.height)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(10)
                }
                .frame(width: size.width, height: size.height)
                
                Text(title.capitalized)
                    .lineLimit(2)
                    .frame(minWidth: size.width - horizontalPadding)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: size.width)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 4)
            .padding(.vertical, 8)
        }

//    }
}

#Preview {
    ListItemView(image: "https://gero3d.com/wp-content/uploads/2024/09/Cast-B.webp",
                 title: "SHORT ARM CAST",
                 size: .init(width: UIScreen.main.bounds.width - 32, height: 160))
}

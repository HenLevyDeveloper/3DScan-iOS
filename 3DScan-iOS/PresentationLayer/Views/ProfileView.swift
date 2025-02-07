//
//  ProfileView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 08/02/2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var recentScans: [ScanModel] = [
        ScanModel(id: 1, name: "Right Hand", date: "Feb 5, 2025"),
        ScanModel(id: 2, name: "Left Foot", date: "Jan 28, 2025"),
        ScanModel(id: 3, name: "Head", date: "Jan 10, 2025")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Profile Header
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    
                    Text("John Doe") // Replace with dynamic user name
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
                
                // Recent Scans List
                List(recentScans) { scan in
                    NavigationLink(destination: ScanDetailView(scan: scan)) {
                        HStack {
                            Image(systemName: "cube.box.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(scan.name)
                                    .font(.headline)
                                Text(scan.date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ScanModel: Identifiable {
    let id: Int
    let name: String
    let date: String
}

struct ScanDetailView: View {
    let scan: ScanModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(scan.name)
                .font(.title)
                .fontWeight(.bold)
            
            Image(systemName: "cube.box.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                
            Button(action: {
                shareScan(scan)
            }) {
                Label("Share Scan", systemImage: "square.and.arrow.up")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
    
    func shareScan(_ scan: ScanModel) {
        // Implement sharing logic here
        print("Sharing scan: \(scan.name)")
    }
}

#Preview {
    ProfileView()
}

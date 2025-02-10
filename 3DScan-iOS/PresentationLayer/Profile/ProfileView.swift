//
//  ProfileView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 08/02/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
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
                    
                    Text(viewModel.username)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
                
                // User Scans List
                List(viewModel.scans) { scan in
                    NavigationLink(destination: ScanDetailView(scan: scan)) {
                        HStack {
                            Image(systemName: "cube.box.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.lightBlue)
                            
                            VStack(alignment: .leading) {
                                Text(scan.fileName)
                                    .font(.headline)
                                Text(scan.createdAtFormatted)
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
            .task {
                await viewModel.fetchScans()
            }
        }
    }
}

struct ScanDetailView: View {
    let scan: Scan
    
    var body: some View {
        VStack(spacing: 20) {
            Text(scan.fileName)
                .font(.title)
                .fontWeight(.bold)
            
            Image(systemName: "cube.box.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.lightBlue)
            
            VStack {
                ModelViewerView(viewModel: .create(withExternalFileKey: scan.key, userId: scan.userId))
                    .frame(height: 300)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
            }
            
            // Share Scan Button
            Button {
                shareScan(scan)
            } label: {
                AppButtonText("Share Scan")
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    func shareScan(_ scan: Scan) {
        let activityVC = UIActivityViewController(activityItems: [scan.url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let target = window.rootViewController {
            target.present(activityVC, animated: true)
        }
    }
}


#Preview {
    let useCase = GetUserScansUseCase(repository: ScanRepository(apiService: APIService()))
    let viewModel = ProfileViewModel(getUserScansUseCase: useCase,
                                     userID: "67a4c07d8d7db26fb9e7324c",
                                     username: "Hen Levy")
    ProfileView(viewModel: viewModel)
}

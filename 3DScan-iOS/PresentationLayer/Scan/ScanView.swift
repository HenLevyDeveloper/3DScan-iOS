//
//  ScanView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

struct ScanView: View {
    @State private var showScanSheet = false
    
    var body: some View {
        VStack {
            Button("Scan") {
                showScanSheet = true
            }
        }
        .fullScreenCover(isPresented: $showScanSheet) {
            ScannerView()
        }
    }
}

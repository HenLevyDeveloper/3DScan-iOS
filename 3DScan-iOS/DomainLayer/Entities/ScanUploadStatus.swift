//
//  ScanUploadStatus.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

enum ScanUploadStatus {
    case idle
    case scanning
    case ready(URL)
    case uploading
    case success(String)
    case failure(String)

    var description: String {
        switch self {
        case .idle:
            return "Waiting for scan..."
        case .scanning:
            return "Scanning..."
        case .ready:
            return "Scan ready for upload"
        case .uploading:
            return "Uploading..."
        case .success(let url):
            return "Uploaded to: \(url)"
        case .failure(let error):
            return "Error: \(error)"
        }
    }
}

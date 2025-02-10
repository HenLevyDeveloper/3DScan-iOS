//
//  Scan.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

struct Scan: Codable, Identifiable {
    let id: String
    let userId: String
    let key: String
    let url: String
    let createdAt: String
    
    var fileName: String {
        key.components(separatedBy: "/").last ?? "3D Model"
    }
    
    var createdAtFormatted: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
        if let date = isoFormatter.date(from: createdAt) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        return "Unknown Date"
    }
}

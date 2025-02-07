//
//  APIService.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation
import Moya

@MainActor
class APIService {
    let provider = MoyaProvider<APIEndpoints>()

    func request(_ target: APIEndpoints) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("✅ API Success: \(target.path)")
                    print("🔹 Status Code: \(response.statusCode)")
                    print("🔹 Response Body: \(String(data: response.data, encoding: .utf8) ?? "Invalid Response")")
                    
                    continuation.resume(returning: response)

                case .failure(let error):
                    print("❌ API Failure: \(target.path)")
                    print("🔹 Error: \(error.localizedDescription)")

                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

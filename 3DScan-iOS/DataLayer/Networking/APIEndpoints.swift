//
//  APIEndpoints.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation
import Moya

enum APIEndpoints {
    case login(email: String, password: String)
    case register(name: String, email: String, password: String)
    case uploadScan(userId: String, scanFile: Data, fileName: String)
    case getUserScans(userId: String)
    case getOrderStatus(orderId: String)
    case getProductsSolutions
}

extension APIEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: "http://ec2-23-22-29-22.compute-1.amazonaws.com:8080/api")!
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .uploadScan: return "/scan/upload"
        case .getUserScans(let userId): return "/scan/\(userId)"
        case .getOrderStatus(let orderId): return "/order/\(orderId)"
        case .getProductsSolutions: return "/products/solutions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .uploadScan:
            return .post
        case .getUserScans, .getOrderStatus, .getProductsSolutions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
            
        case .register(let name, let email, let password):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password], encoding: JSONEncoding.default)
            
        case .uploadScan(let userId, let scanFile, let fileName):
            let formData: [Moya.MultipartFormData] = [
                .init(provider: .data(scanFile), name: "scan", fileName: fileName, mimeType: "model/vnd.usdz+zip"),
                .init(provider: .data(userId.data(using: .utf8)!), name: "userId")
            ]
            return .uploadMultipart(formData)
            
        case .getUserScans, .getOrderStatus, .getProductsSolutions:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

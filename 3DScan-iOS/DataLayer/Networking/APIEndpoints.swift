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
    case upload(fileURL: URL, presignedURL: URL)
    case generateScanPresignedUrl(userId: String, fileName: String)
    case getViewPresignedURL(userId: String, fileKey: String)
    case getUserScans(userId: String)
    case getOrderStatus(orderId: String)
    case getProductsSolutions
    case getBodyParts
}

extension APIEndpoints: TargetType {
    var baseURL: URL {
        switch self {
        case .upload(_, let presignedURL):
            return presignedURL
        default:
            return URL(string: "http://ec2-23-22-29-22.compute-1.amazonaws.com:8080/api")!
        }
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .upload: return ""
        case .generateScanPresignedUrl: return "/scan/generate-presigned-url"
        case .getViewPresignedURL(let userId, let fileKey): return "/scan/scans/\(userId)/presigned-url/\(fileKey)"
        case .getUserScans(let userId): return "/scan/scans/\(userId)"
        case .getOrderStatus(let orderId): return "/order/\(orderId)"
        case .getProductsSolutions: return "/products/solutions"
        case .getBodyParts: return "/scan/body-parts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .generateScanPresignedUrl:
            return .post
        case .getUserScans, .getOrderStatus, .getProductsSolutions, .getBodyParts, .getViewPresignedURL:
            return .get
        case .upload:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
            
        case .register(let name, let email, let password):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password], encoding: JSONEncoding.default)
            
        case .generateScanPresignedUrl(let userId, let fileName):
            return .requestParameters(parameters: ["userId": userId, "fileName": fileName], encoding: JSONEncoding.default)
            
        case .getUserScans, .getOrderStatus, .getProductsSolutions, .getBodyParts, .getViewPresignedURL:
            return .requestPlain
            
        case .upload(let fileURL, _):
            do {
                let fileData = try Data(contentsOf: fileURL)
                return .requestData(fileData)
            } catch {
                fatalError("Error reading file: \(error.localizedDescription)")
            }
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .upload:
            return ["Content-Type": "application/octet-stream"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

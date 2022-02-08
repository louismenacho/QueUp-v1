//
//  APIRequest.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/17/21.
//

import Foundation

struct APIRequest {
    var baseURL: String
    var method: HTTPMethod = .get
    var path: String = ""
    var params: [String: Any] = [:]
    var header: [String: String] = [:]
    var body: [String: Any] = [:]
    var auth: HTTPAuthorization = .none
        
    private var requestURL: URL {
        var components = URLComponents(url: URL(string: baseURL)!, resolvingAgainstBaseURL: true)!
        components.path.append(path)
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return components.url!
    }
    
    private var requestHeader: [String: String] {
        var header = header
        
        switch auth {
            case let .basic(username, password):
                let base64Credentials = (username+":"+password).data(using: .utf8)!.base64EncodedString()
                header["Authorization"] = "Basic \(base64Credentials)"
            case let .bearer(token):
                header["Authorization"] = "Bearer \(token)"
            case .none:
                break
        }
        
        return header
    }
    
    private var requestBody: Data? {
        switch header["Content-Type"] {
            case "application/x-www-form-urlencoded":
                var components = URLComponents()
                components.queryItems = body.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                return components.query?.data(using: .utf8)
            case "application/json":
                do {
                    return try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                } catch {
                    print(error)
                    return nil
                }
            default:
                return nil
        }
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeader
        request.httpBody = requestBody
        return request
    }
}

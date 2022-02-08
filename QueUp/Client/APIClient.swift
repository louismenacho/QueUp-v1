//
//  APIClient.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/17/21.
//

import Foundation

protocol APIClient {
    associatedtype Endpoint: APIEndpoint
    var auth: HTTPAuthorization { get set }
}

extension APIClient {
    func request<DataType: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<DataType, ClientError>) -> Void) {
        var apiRequest = endpoint.request
        apiRequest.auth = self.auth
        
        URLSession.shared.dataTask(with: apiRequest.asURLRequest()) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            guard 200...299 ~= response.statusCode else {
                let statusCode = response.statusCode
                let statusDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                completion(.failure(.badResponse(code: statusCode, description: statusDescription, json: json(from: data))))
                return
            }
            
            if response.statusCode == 204 {
                let emptyData = try! JSONDecoder().decode(DataType.self, from: EmptyData().encoded())
                completion(.success(emptyData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(DataType.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        .resume()
    }
    
    func json(from data: Data) -> AnyObject {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self) as AnyObject
        } else {
            return "json data malformed" as AnyObject
        }
    }
}

struct EmptyData: Codable {
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

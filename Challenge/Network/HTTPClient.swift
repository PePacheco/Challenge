//
//  HTTPClient.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

enum APIError: Error {
    case badUrl
    case decodingFailed
}

class HTTPClient {
    
    let headers: [String: String]
    
    init(withHeaders headers: [String: String]) {
        self.headers = headers
    }
    
    func get<T: Codable>(url: String) -> AnyPublisher<T, APIError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        self.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { _ in Fail(error: APIError.decodingFailed) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

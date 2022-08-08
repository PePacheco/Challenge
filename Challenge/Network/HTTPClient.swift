//
//  HTTPClient.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class HTTPClient {
    
    let headers: [String: String]
    
    init(withHeaders headers: [String: String]) {
        self.headers = headers
    }
    
    func get<T: Codable>(url: String) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let url = URL(string: url) else {
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            self.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
        
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}

//
//  MoviesRepository.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class MoviesRepository {
    
    let client: HTTPClient
    
    init() {
        let headers = [
            "X-RapidAPI-Key": "31e9e13f4fmsh551f24ec76a71a9p11502ajsn31497639b601"
        ]
        self.client = HTTPClient(withHeaders: headers)
    }
    
    func getAllMovies() -> Observable<MovieResponse> {
        let observable: Observable<MovieResponse> = self.client.get(url: "https://movies-app1.p.rapidapi.com/api/movies")
        return observable
    }
    
}

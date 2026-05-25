//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Adilkhan on 18/5/26.
//

import Foundation

protocol MoviesLoading {
    func fetchMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRoutingProtocol
    private let decoder = JSONDecoder()
    
    init(networkClient: NetworkRoutingProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: movieUrlString + apiKey) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func fetchMovies(completion: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try decoder.decode(MostPopularMovies.self, from: data)
                    completion(.success(mostPopularMovies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

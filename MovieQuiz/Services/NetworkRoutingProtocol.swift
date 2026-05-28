//
//  NetworkClientProtocol.swift
//  MovieQuiz
//
//  Created by Adilkhan on 25/5/26.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}


//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Adilkhan on 10/5/26.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResultModel { get }
    var totalAccuracy: Double { get }
    
    func store(save gameResult: GameResultModel)
}

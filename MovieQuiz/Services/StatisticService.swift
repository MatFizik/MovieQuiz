//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Adilkhan on 10/5/26.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResultModel {
        get {
            GameResultModel(
                correct: storage.integer(forKey: Keys.bestGameCorrectAnswers.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotalAnswers.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrectAnswers.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotalAnswers.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            if totalCorrectAnswers != 0 && totalQuestionsAsked != 0 {
                Double((Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100)
            } else {
                Double(0)
            }
        }
    }
    
    func store(save gameResult: GameResultModel) {
        totalCorrectAnswers += gameResult.correct
        totalQuestionsAsked += gameResult.total
        gamesCount += 1
        
        if gameResult.isBetter(to: bestGame) {
            bestGame = GameResultModel(correct: gameResult.correct,
                                       total: gameResult.total,
                                       date: Date())
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrectAnswers
        case bestGameTotalAnswers
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    
}

//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Adilkhan on 10/5/26.
//

import Foundation

struct GameResultModel{
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(to another: GameResultModel) -> Bool {
        correct > another.correct || another.total != total
    }
}

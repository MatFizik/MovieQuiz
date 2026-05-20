//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Adilkhan on 2/5/26.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

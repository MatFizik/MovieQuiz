//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Adilkhan on 27/5/26.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(quiz step: QuizStepViewModel)
    func showResultAlert(quiz result: QuizResultViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

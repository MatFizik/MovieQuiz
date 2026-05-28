//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Adilkhan on 27/5/26.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestionIndex: Int = 0
    
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestQuestion()
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            imageData: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func makeResultsMessage() -> String {
        statisticService?.store(save: GameResultModel(
            correct: correctAnswers, total: questionsAmount, date: Date()
        ))
        
        let bestGame = statisticService?.bestGame
        
        let currentDate: String = bestGame?.date.dateTimeString ?? ""
        
        let resultMessage: String =
        """
        Ваш результат: \(correctAnswers)/\(questionsAmount)\n
        Количество сыгранных игр: \(statisticService?.gamesCount ?? 1)
        Рекорд: \(bestGame?.correct ?? correctAnswers)/\(bestGame?.total ?? questionsAmount) (\(currentDate))\n
        Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%
        """
        
        return resultMessage
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        correctAnswers += isYes == currentQuestion.correctAnswer ? 1 : 0
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    // MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        viewController?.hideLoadingIndicator()
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(quiz: viewModel)
        }
        
    }
    
    // MARK: -Private Methods
    private func proceedToNextQuestionOrResults(){
        if isLastQuestion {
            
            let modalMessage = makeResultsMessage()
            let modalTitle: String = "Этот раунд окончен!"
            let modalButtonLabel: String = "Сыграть еще раз"
            
            viewController?.showResultAlert(quiz: QuizResultViewModel(title: modalTitle,
                                                                      text: modalMessage,
                                                                      buttonText: modalButtonLabel))
        }
        else {
            switchToNextQuestion()
            viewController?.showLoadingIndicator()
            questionFactory?.requestQuestion()
            let quizStep = convert(model: currentQuestion!)
            viewController?.showQuestion(quiz: quizStep)
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
}


//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Adilkhan on 27/5/26.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var lastStepModel: QuizStepViewModel?
    
    func showQuestion(quiz step: QuizStepViewModel) {
        lastStepModel = step
    }
    func showResultAlert(quiz result: QuizResultViewModel) {}
    func highlightImageBorder(isCorrect: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(imageData: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        viewControllerMock.showQuestion(quiz: viewModel)
        
        XCTAssertEqual(viewControllerMock.lastStepModel?.imageData, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}


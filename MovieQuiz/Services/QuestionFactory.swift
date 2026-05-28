//
//   QuestionFactory.swift
//  MovieQuiz
//
//  Created by Adilkhan on 28/4/26.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol{
    private let moviesLoader: MoviesLoading
    
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    // массив mock-вопросов
    //private let questions: [QuizQuestion] = [
    //        QuizQuestion(
    //        image: "The Godfather",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "The Dark Knight",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "Kill Bill",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "The Avengers",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "Deadpool",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "The Green Knight",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: true),
    //        QuizQuestion(
    //        image: "Old",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: false),
    //        QuizQuestion(
    //        image: "The Ice Age Adventures of Buck Wild",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: false),
    //        QuizQuestion(
    //        image: "Tesla",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: false),
    //        QuizQuestion(
    //        image: "Vivarium",
    //        text: "Рейтинг этого фильма больше чем 6?",
    //        correctAnswer: false),
    //    ]
    //    private var shaffleQueue: [QuizQuestion]
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate){
        self.moviesLoader = moviesLoader
        self.delegate = delegate
        //      self.shaffleQueue = questions.shuffled()
    }
    
    func requestQuestion() {
        requestNextQuestion()
        //        if shaffleQueue.isEmpty {
        //            shaffleQueue = questions.shuffled()
        //        }
        //        let next = shaffleQueue.removeFirst()
        //        delegate?.didReceiveNextQuestion(question: next)
    }
    
    internal func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard !self.movies.isEmpty else { return }
            let movie = self.movies.first!
            
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let text: String
            let correctAnswer: Bool
            
            if Bool.random() {
                text = "Рейтинг этого фильма больше чем \(Int(rating.rounded()))?"
                correctAnswer = rating > rating.rounded()
            } else {
                text = "Рейтинг этого фильма меньше чем \(Int(rating.rounded()))?"
                correctAnswer = rating < rating.rounded()
            }
            
            let question = QuizQuestion(imageData: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
            if !self.movies.isEmpty {
                movies.remove(at: 0)
            }
        }
    }
    
    func loadData() {
        moviesLoader.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}

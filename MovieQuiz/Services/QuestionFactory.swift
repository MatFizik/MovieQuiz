//
//   QuestionFactory.swift
//  MovieQuiz
//
//  Created by Adilkhan on 28/4/26.
//

class QuestionFactory: QuestionFactoryProtocol{
    
    weak var delegate: QuestionFactoryDelegate?

    // массив mock-вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
        image: "The Godfather",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "The Dark Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "Kill Bill",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "The Avengers",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "Deadpool",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "The Green Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
        QuizQuestion(
        image: "Old",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
        QuizQuestion(
        image: "The Ice Age Adventures of Buck Wild",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
        QuizQuestion(
        image: "Tesla",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
        QuizQuestion(
        image: "Vivarium",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    ]
    private var shaffleQueue: [QuizQuestion]

    init(delegate: QuestionFactoryDelegate){
        self.delegate = delegate
        self.shaffleQueue = questions.shuffled()
    }
    
    func requestQuestion() {
        if shaffleQueue.isEmpty {
            shaffleQueue = questions.shuffled()
        }
        let next = shaffleQueue.removeFirst()
        delegate?.didReceiveNextQuestion(question: next)
    }
}

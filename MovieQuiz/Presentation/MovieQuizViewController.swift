import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var previewImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
    }
}

struct QuizQuestion{
    let image: String
    let text: String
    let correctAnswer: Bool
}

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

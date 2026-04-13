import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var previewImage: UIImageView!
    
    private var currentQuestionIndex: Int = 0
    private var currentQuestion = QuizQuestion(image: "", text: "", correctAnswer: true)
    
    private var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentQuestion = questions[currentQuestionIndex]
        let quizStep = convert(model: currentQuestion)
    
        show(quiz: quizStep)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel){
        previewImage.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool){
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQiuestionOrResult()
            self.previewImage.layer.borderColor = nil
            self.previewImage.layer.borderWidth = 0.0
        }
        
        
    }
    
    private func showNextQiuestionOrResult(){
        if currentQuestionIndex == questions.count - 1 {}
        else {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            let quizStep = convert(model: currentQuestion)
            show(quiz: quizStep)
        }
    }
}

struct QuizQuestion{
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
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

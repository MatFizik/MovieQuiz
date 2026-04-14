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
    
        showQuestion(quiz: quizStep)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func showQuestion(quiz step: QuizStepViewModel){
        previewImage.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        YesButton.isEnabled = true
        NoButton.isEnabled = true
    }
    
    private func showResultAlert(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.currentQuestion = questions[self.currentQuestionIndex]
            
            let quizStep = self.convert(model: self.currentQuestion)
            
            self.showQuestion(quiz: quizStep)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
        }
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        YesButton.isEnabled = false
        NoButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.previewImage.layer.borderColor = UIColor.clear.cgColor
            self.previewImage.layer.borderWidth = 0.0
            self.showNextQiuestionOrResult()
        }
    }
    
    private func showNextQiuestionOrResult(){
        if currentQuestionIndex == questions.count - 1 {
            let modalTitle: String = "Этот раунд окончен!"
            let modalMessage: String = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let modalButtonLabel: String = "Сыграть еще раз"
            showResultAlert(quiz: QuizResultViewModel(title: modalTitle,
                                           text: modalMessage,
                                           buttonText: modalButtonLabel))
        }
        else {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            let quizStep = convert(model: currentQuestion)
            showQuestion(quiz: quizStep)
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

struct QuizResultViewModel {
    let title: String
    let text: String
    let buttonText: String
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

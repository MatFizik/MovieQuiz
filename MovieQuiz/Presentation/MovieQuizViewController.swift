import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var previewImage: UIImageView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter = AlertPresenter()
    
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuestion(quiz: viewModel)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        statisticService = StatisticService()
        
        questionFactory?.requestQuestion()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: !(currentQuestion?.correctAnswer ?? false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: currentQuestion?.correctAnswer ?? true)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func showQuestion(quiz step: QuizStepViewModel){
        previewImage.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        YesButton.isEnabled = true
        NoButton.isEnabled = true
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.previewImage.layer.borderColor = UIColor.clear.cgColor
            self.previewImage.layer.borderWidth = 0.0
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult(){
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(save: GameResultModel(
                correct: correctAnswers, total: questionsAmount, date: Date()
            ))
            
            let currentDate: String = statisticService?.bestGame.date.dateTimeString ?? ""
            let modalTitle: String = "Этот раунд окончен!"
            let modalMessage: String = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n" +
            "Количество сыгранных игр: \(statisticService?.gamesCount ?? 1)\n" +
            "Рекорд: \(statisticService?.bestGame.correct ?? correctAnswers)/\(statisticService?.bestGame.total ?? questionsAmount) (\(currentDate))\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%"
            let modalButtonLabel: String = "Сыграть еще раз"
            showResultAlert(quiz: QuizResultViewModel(title: modalTitle,
                                           text: modalMessage,
                                           buttonText: modalButtonLabel))
        }
        else {
            currentQuestionIndex += 1
            self.questionFactory?.requestQuestion()
            guard let currentQuestion = currentQuestion else {return}
            let quizStep = convert(model: currentQuestion)
            showQuestion(quiz: quizStep)
        }
    }
    
    
    private func showResultAlert(quiz result: QuizResultViewModel) {
            let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestQuestion()
        }
        alertPresenter.showAlert(data: alertModel, viewController: self)
    }
}

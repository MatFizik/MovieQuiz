import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter = AlertPresenter()
    private var presenter = MovieQuizPresenter()
    
    private var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        statisticService = StatisticService()
        
        presenter.viewController = self
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Public Methods
    
    func didLoadDataFromServer() {
        showLoadingIndicator()
        questionFactory?.requestQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        hideLoadingIndicator()
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuestion(quiz: viewModel)
        }
        
    }
    
    // MARK: - Private Methods
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()

    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        YesButton.isEnabled = true
        NoButton.isEnabled = true
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        YesButton.isEnabled = false
        NoButton.isEnabled = false
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") {[weak self] in
            guard let self = self else {return}
            
            self.correctAnswers = 0
            presenter.resetQuestionIndex()
            
            showLoadingIndicator()
            self.questionFactory?.requestQuestion()
        }
        
        alertPresenter.showAlert(data: alertModel, viewController: self)
    }
    
    private func showQuestion(quiz step: QuizStepViewModel){
        let modelViewImage = UIImage(data: step.image) ?? UIImage()
        
        previewImage.image = modelViewImage
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        YesButton.isEnabled = true
        NoButton.isEnabled = true
    }
    
    func showAnswerResult(isCorrect: Bool) {
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
        if presenter.isLastQuestion() {
            statisticService?.store(save: GameResultModel(
                correct: correctAnswers, total: presenter.questionsAmount, date: Date()
            ))
            
            let currentDate: String = statisticService?.bestGame.date.dateTimeString ?? ""
            let modalTitle: String = "Этот раунд окончен!"
            let modalMessage: String = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\n" +
            "Количество сыгранных игр: \(statisticService?.gamesCount ?? 1)\n" +
            "Рекорд: \(statisticService?.bestGame.correct ?? correctAnswers)/\(statisticService?.bestGame.total ?? presenter.questionsAmount) (\(currentDate))\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%"
            let modalButtonLabel: String = "Сыграть еще раз"
            showResultAlert(quiz: QuizResultViewModel(title: modalTitle,
                                           text: modalMessage,
                                           buttonText: modalButtonLabel))
        }
        else {
            presenter.switchToNextQuestion()
            showLoadingIndicator()
            self.questionFactory?.requestQuestion()
            guard let currentQuestion = currentQuestion else {return}
            let quizStep = presenter.convert(model: currentQuestion)
            showQuestion(quiz: quizStep)
        }
    }
    
    
    private func showResultAlert(quiz result: QuizResultViewModel) {
            let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else {return}
                presenter.resetQuestionIndex()
                self.correctAnswers = 0
                showLoadingIndicator()
                questionFactory?.requestQuestion()
            }
        alertPresenter.showAlert(data: alertModel, viewController: self)
    }
}

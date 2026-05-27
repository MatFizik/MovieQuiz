import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet private weak var YesButton: UIButton!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    // MARK: - Public Methods
    func showQuestion(quiz step: QuizStepViewModel){
        let modelViewImage = UIImage(data: step.image) ?? UIImage()
        
        previewImage.image = modelViewImage
        previewImage.layer.borderColor = UIColor.clear.cgColor
        
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        YesButton.isEnabled = true
        NoButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        YesButton.isEnabled = false
        NoButton.isEnabled = false
    }
    
    func showResultAlert(quiz result: QuizResultViewModel) {
            let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else {return}
                presenter.restartGame()
                showLoadingIndicator()
            }
        alertPresenter.showAlert(data: alertModel, viewController: self)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") {[weak self] in
            guard let self = self else {return}
            
            presenter.restartGame()
            showLoadingIndicator()
        }
        
        alertPresenter.showAlert(data: alertModel, viewController: self)
    }
    // MARK: -LoadingIndicator
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        YesButton.isEnabled = true
        NoButton.isEnabled = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        YesButton.isEnabled = false
        NoButton.isEnabled = false
    }
    // MARK: - Private Methods
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()

    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
}

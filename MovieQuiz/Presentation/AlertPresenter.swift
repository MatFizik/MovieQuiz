//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Adilkhan on 9/5/26.
//

import UIKit

final class AlertPresenter {
    func showAlert(data: AlertModel, viewController: UIViewController) {
        let alert = UIAlertController(title: data.title,
                                      message: data.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: data.buttonText,
                                   style: .default) { _ in
            data.completion()
        }
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

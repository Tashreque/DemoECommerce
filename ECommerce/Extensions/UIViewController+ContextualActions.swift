//
//  UIViewController+ContextualActions.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func showDefaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func getControllerFromStoryboard(storyboardName: String, classIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: classIdentifier)
        return controller
    }

    func popMultipleViewControllers(numberToPop: Int, animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            let lastIndex = viewControllers.count - 1
            self.navigationController?.popToViewController(viewControllers[lastIndex - numberToPop], animated: animated)
        }
    }
}

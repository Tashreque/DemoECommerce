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
}

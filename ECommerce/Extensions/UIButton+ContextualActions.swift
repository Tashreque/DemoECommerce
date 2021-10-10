//
//  UIButton+ContextualActions.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import Foundation
import UIKit

extension UIButton {
    func disableButton(withAlpha alpha: CGFloat) {
        self.isEnabled = false
        self.alpha = alpha
    }

    func enableButton() {
        self.isEnabled = true
        self.alpha = 1
    }
}

//
//  UIView.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import Foundation
import UIKit

extension UIView {
    func setBorder(borderWidth: CGFloat, color: UIColor?) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color?.cgColor
    }
}

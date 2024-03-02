//
//  UIFont+Ext.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 1.03.2024.
//

import Foundation
import UIKit

extension UIFont {
    var boldVersion: UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }

        return UIFont(descriptor: descriptor, size: .zero)
    }
}

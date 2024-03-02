//
//  FontSize.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 1.03.2024.
//

import Foundation
import UIKit

enum FontSize {
    case body
    case subtitle
    case headline
    case header
    
    var rawValue: CGFloat {
        switch self {
        case .subtitle:
            return 12
        case .body:
            return 16
        case .headline:
            return 20
        case .header:
            return 35
        }
    }
    
    var toFont: UIFont {
        return .systemFont(ofSize: rawValue)
    }
}

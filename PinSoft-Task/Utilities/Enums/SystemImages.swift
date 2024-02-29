//
//  SystemImages.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation
import UIKit

enum SystemImages {
    case house
    case favorite

    var rawValue: String {
        switch self {
        case .house:
            return "house"
        case .favorite:
            return "heart"
        }
        
    }
    
    var toSelected: UIImage? {
        return UIImage(systemName: "\(rawValue).fill")
    }
    
    var normal: UIImage? {
        return UIImage(systemName: rawValue)
    }
    
}

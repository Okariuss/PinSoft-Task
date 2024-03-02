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
    case wind
    case humidity

    var rawValue: String {
        switch self {
        case .house:
            return "house"
        case .favorite:
            return "heart"
        case .wind:
            return "wind"
        case .humidity:
            return "humidity"
        }
        
    }
    
    var toSelected: UIImage {
        return UIImage(systemName: "\(rawValue).fill")!
    }
    
    var normal: UIImage {
        return (UIImage(systemName: rawValue)?.withRenderingMode(.alwaysOriginal).withTintColor(.white))!
    }

    
}

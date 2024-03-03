//
//  BaseProtocol.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 2.03.2024.
//

import Foundation
import UIKit

protocol BaseViewModelProtocol {
    var delegate: BaseViewModelDelegate? { get set }
    var viewController: UIViewController? { get set }
    
    func animateCell(_ cell: WeatherTableViewCell)
}

extension BaseViewModelProtocol {
    func animateCell(_ cell: WeatherTableViewCell) {
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }
}

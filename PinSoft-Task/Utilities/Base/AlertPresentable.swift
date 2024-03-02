//
//  AlertPresentable.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation
import UIKit

protocol AlertDialogPresenter {
    func presentAlertDialog(message: String, in viewController: UIViewController)
}

extension UIAlertController: AlertDialogPresenter {
    func presentAlertDialog(message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

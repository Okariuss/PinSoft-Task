//
//  CommonComponents.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 2.03.2024.
//

import Foundation
import UIKit

final class CommonComponents {
    private init() {}
    
    static func makeView<T: UIView>() -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func makeTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Theme.defaultTheme.themeFont.headerFont
        label.text = text
        return label
    }
    
    static func makeSearchController(placeholder text: String) -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = text
        return searchController
    }
    
    static func addLabel(view: UIView, label: UILabel, font: UIFont = Theme.defaultTheme.themeFont.bodyFont) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = font
        label.textColor = .white
    }
    
    static func addImage(view: UIView, image: UIImageView) {
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
    }
}

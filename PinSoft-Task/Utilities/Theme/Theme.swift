//
//  Theme.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 1.03.2024.
//

import Foundation

struct Theme {
    let themeFont: ThemeFont
}

extension Theme {
    static var defaultTheme: Theme {
        return Theme(
            themeFont: ThemeFont(
                headerFont: FontSize.header.toFont.boldVersion,
                headlineFont: FontSize.headline.toFont.boldVersion,
                bodyFont: FontSize.body.toFont,
                subtitleFont: FontSize.subtitle.toFont
            )
        )
    }
}

//
//  BaseViewModelDelegate.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 2.03.2024.
//

import Foundation

protocol BaseViewModelDelegate: AnyObject, AlertDialogPresenter {
    func updateUI()
    func favoritesDidUpdate()
    func toggleNavigationBar(hidden: Bool, duration: Double)
}


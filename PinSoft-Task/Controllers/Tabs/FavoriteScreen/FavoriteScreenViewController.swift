//
//  FavoriteScreenViewController.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import UIKit

class FavoriteScreenViewController: UIViewController  {
    
    private var viewModel = FavoriteViewModel()
    
    private let titleLabel: UILabel = {
        return CommonComponents.makeTitleLabel(AppConstants.LocalizationConstants.favoriteTitle)
    }()
    
    private let tableView: UITableView = {
        return CommonComponents.makeView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViewModel()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.viewController = self
        viewModel.loadFavorites()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = .dHeight / 6
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.weatherInfoCellIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoriteScreenViewController: UITableViewDataSource, UITableViewDelegate, BaseViewModelDelegate {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationController?.setNavigationBarHidden(self.viewModel.isNavBarHidden, animated: true)
        }
    }
    
    func toggleNavigationBar(hidden: Bool, duration: Double) {
        navigationController?.setNavigationBarHidden(self.viewModel.isNavBarHidden, animated: true)
        UIView.animate(withDuration: duration) {
            self.titleLabel.alpha = hidden ? 0 : 1
        }
    }
    
    func presentAlertDialog(message: String, in viewController: UIViewController) {
        UIAlertController().presentAlertDialog(message: message, in: self)
    }
    
    func favoritesDidUpdate() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.weatherInfoCellIdentifier, for: indexPath) as? WeatherTableViewCell else {
            fatalError("Could not dequeue WeatherTableViewCell")
        }

        let item = viewModel.favorites[indexPath.row]
        cell.configure(with: item)
        
        cell.favoriteButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeFavorite(item)
            favoritesDidUpdate()
        }
        
        let isFavorite = viewModel.favorites.contains { $0.id == item.id }
        cell.favoriteButton.setImage(isFavorite ? SystemImages.favorite.toSelected : SystemImages.favorite.normal, for: .normal)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return }
        
        viewModel.animateCell(cell)
    }
}

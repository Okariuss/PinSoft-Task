//
//  HomeScreenViewController.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.defaultTheme.themeFont.headerFont
        label.text = "Weather"
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        setupViewModel()
        setupNavigationBar()
        setupTableView()
        setupSpinner()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.viewController = self
        viewModel.fetchWeatherData()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search for a city"
            navigationItem.searchController = searchController
            
            definesPresentationContext = true
    }

    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = .dHeight / 6
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherInfoCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSpinner() {
        spinner.hidesWhenStopped = true
        spinner.color = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        tableView.tableFooterView = spinner
    }
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate, HomeViewModelDelegate, UIScrollViewDelegate, UISearchResultsUpdating {
    func toggleNavigationBar(hidden: Bool, duration: Double) {
        navigationController?.setNavigationBarHidden(viewModel.toggleNavBar(), animated: true)
        UIView.animate(withDuration: duration) {
            self.titleLabel.alpha = hidden ? 0 : 1
        }
    }
    
    func presentAlertDialog(message: String, in viewController: UIViewController) {
        UIAlertController().presentAlertDialog(message: message, in: self)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.spinner.stopAnimating()
            self.navigationController?.setNavigationBarHidden(self.viewModel.isNavBarHidden, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherTableViewCell
        
        let weatherData = viewModel.displayedWeatherData[indexPath.row]
        cell.configure(with: weatherData)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        viewModel.scrollViewDidScroll(offsetY: offsetY, contentHeight: contentHeight, screenHeight: screenHeight, spinner: spinner)
    }
    
    @objc private func loadMoreData() {
        viewModel.loadMoreWeatherData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            viewModel.refreshWeatherData()
            viewModel.filterWeatherData(by: "")
        } else {
            let searchText = searchController.searchBar.text ?? ""
            viewModel.filterWeatherData(by: searchText)
        }
    }
}

//
//  WeatherDetailScreenViewController.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 3.03.2024.
//

import UIKit

final class WeatherDetailScreenViewController: UIViewController {
    
    var weatherInfo: WeatherInfo?
    
    private var viewModel: WeatherDetailsViewModel!
    
    private let cityLabel = UILabel()
    private let countryLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let humidityImage = UIImageView(image: SystemImages.humidity.normal)
    private let humidityLabel = UILabel()
    private let windSpeedImage = UIImageView(image: SystemImages.wind.normal)
    private let windSpeedLabel = UILabel()
    private let backgroundImageView = UIImageView()
    let favoriteButton = UIButton(type: .system)
    
    private let tableView: UITableView = {
        return CommonComponents.makeView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteStatus()
    }
    
    private func setupUI() {
        backgroundImageViewConstraints()
        setupNavigationBar()
        setupViewModel()
        labelsConstraints()
        setupTableView()
        configureFavoriteButton()
        configure(with: weatherInfo)
    }
    
    private func backgroundImageViewConstraints() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = AppConstants.RadiusConstants.normal.rawValue
        backgroundImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupViewModel() {
        guard let weatherInfo = weatherInfo else { return }
        viewModel = WeatherDetailsViewModel(weatherInfo: weatherInfo)
    }
    
    private func labelsConstraints() {
        CommonComponents.addImage(view: view, image: humidityImage)
        CommonComponents.addImage(view: view, image: windSpeedImage)
        CommonComponents.addLabel(view: view, label: cityLabel, font: Theme.defaultTheme.themeFont.headerFont.boldVersion)
        CommonComponents.addLabel(view: view, label: countryLabel, font: Theme.defaultTheme.themeFont.headlineFont.boldVersion)
        CommonComponents.addLabel(view: view, label: temperatureLabel, font: Theme.defaultTheme.themeFont.headerFont.boldVersion)
        CommonComponents.addLabel(view: view, label: weatherDescriptionLabel, font: Theme.defaultTheme.themeFont.headlineFont.boldVersion)
        CommonComponents.addLabel(view: view, label: humidityLabel)
        CommonComponents.addLabel(view: view, label: windSpeedLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.SpaceConstants.high.rawValue),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            countryLabel.centerXAnchor.constraint(equalTo: cityLabel.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            temperatureLabel.centerXAnchor.constraint(equalTo: countryLabel.centerXAnchor),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: temperatureLabel.centerXAnchor),
            
            humidityImage.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            humidityImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.SpaceConstants.high.rawValue),
            
            humidityLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityImage.trailingAnchor, constant: AppConstants.SpaceConstants.low.rawValue),
            
            windSpeedImage.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            windSpeedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.SpaceConstants.high.rawValue),
            
            windSpeedLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            windSpeedLabel.trailingAnchor.constraint(equalTo: windSpeedImage.leadingAnchor, constant: -AppConstants.SpaceConstants.low.rawValue),
        ])
        
        let rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
            
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = .dHeight / 6
        
        tableView.backgroundColor = .clear
        
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.weatherForecastCellIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: AppConstants.SpaceConstants.high.rawValue),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureFavoriteButton() {
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(SystemImages.favorite.normal, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.tintColor = .red
    }
        
    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavorite()
        updateFavoriteButtonImage(isFavorite: viewModel.isFavorite)
    }
    
    private func updateFavoriteButtonImage(isFavorite: Bool) {
        let favoriteImage = isFavorite ? SystemImages.favorite.toSelected : SystemImages.favorite.normal
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    private func configure(with weatherInfo: WeatherInfo?) {
        guard let weatherInfo = weatherInfo else { return }
        cityLabel.text = "\(weatherInfo.city)"
        countryLabel.text = "\(weatherInfo.country)"
        temperatureLabel.text = "\(weatherInfo.temperature)°"
        weatherDescriptionLabel.text = "\(weatherInfo.weatherDescription.rawValue.capitalized)"
        humidityLabel.text = "Humidity: \(weatherInfo.humidity)%"
        windSpeedLabel.text = "Wind: \(weatherInfo.windSpeed) mph"
        
        configureBackground(with: weatherInfo)
    }
    
    private func configureBackground(with data: WeatherInfo?) {
        let backgroundImageName: String
        
        switch weatherInfo?.weatherDescription {
        case .sunny:
            backgroundImageName = "Sunny"
        case .clearSky:
            backgroundImageName = "ClearSky"
        case .partlyCloudy:
            backgroundImageName = "PartlyCloudy"
        case .scatteredClouds:
            backgroundImageName = "ScatteredCloudy"
        case .cloudy:
            backgroundImageName = "Cloudy"
        case .rainShowers:
            backgroundImageName = "RainShowers"
        case .rain, .rainy:
            backgroundImageName = "Rainy"
        case .none:
            backgroundImageName = ""
        }
        
        if let backgroundImage = UIImage(named: backgroundImageName) {
            backgroundImageView.image = backgroundImage
        }
    }
}

extension WeatherDetailScreenViewController: UITableViewDelegate, UITableViewDataSource, WeatherDetailsViewModelDelegate {
    
    func presentAlertDialog(message: String, in viewController: UIViewController) {
        UIAlertController().presentAlertDialog(message: message, in: self)
    }
    
    func updateFavoriteStatus() {
        DispatchQueue.main.async {
            self.updateFavoriteButtonImage(isFavorite: self.viewModel.isFavorite)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherInfo!.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.weatherForecastCellIdentifier, for: indexPath) as! WeatherForecastTableViewCell
        
        let forecastInfo = weatherInfo!.forecast[indexPath.row]
        cell.configure(with: forecastInfo)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

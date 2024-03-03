//
//  WeatherView.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    private let containerView = UIView()
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
    
    var favoriteButtonPressed: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerViewConstraints()
        
        backgroundImageViewConstraints()
        
        labelsConstraints()
        
        configureFavoriteButton()
    }
    
    private func containerViewConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = AppConstants.RadiusConstants.normal.rawValue
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.SpaceConstants.normal.rawValue),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.SpaceConstants.normal.rawValue),
        ])
    }
    
    private func backgroundImageViewConstraints() {
        containerView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.layer.cornerRadius = AppConstants.RadiusConstants.normal.rawValue
        backgroundImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    private func labelsConstraints() {
        addImage(image: humidityImage)
        addImage(image: windSpeedImage)
        addLabel(label: cityLabel, font: Theme.defaultTheme.themeFont.headlineFont.boldVersion)
        addLabel(label: countryLabel)
        addLabel(label: weatherDescriptionLabel)
        addLabel(label: temperatureLabel, font: Theme.defaultTheme.themeFont.headerFont.boldVersion)
        addLabel(label: humidityLabel)
        addLabel(label: windSpeedLabel)
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            cityLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            
            countryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: AppConstants.SpaceConstants.low.rawValue),
        
            humidityImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            humidityImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppConstants.SpaceConstants.medium.rawValue),
            
            humidityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppConstants.SpaceConstants.medium.rawValue),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityImage.trailingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            
            windSpeedLabel.bottomAnchor.constraint(equalTo: windSpeedImage.bottomAnchor),
            windSpeedLabel.leadingAnchor.constraint(equalTo: windSpeedImage.trailingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            
            windSpeedImage.leadingAnchor.constraint(equalTo: humidityImage.leadingAnchor),
            windSpeedImage.bottomAnchor.constraint(equalTo: humidityImage.topAnchor, constant: -AppConstants.SpaceConstants.low.rawValue),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppConstants.SpaceConstants.medium.rawValue),
            temperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppConstants.SpaceConstants.high.rawValue),
            
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: temperatureLabel.centerXAnchor),
            weatherDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppConstants.SpaceConstants.low.rawValue),
            
        ])
    }
    
    private func configureFavoriteButton() {
        containerView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(SystemImages.favorite.normal, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.tintColor = .red
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppConstants.SpaceConstants.normal.rawValue),
            
        ])
    }
        
    @objc private func favoriteButtonTapped() {
        
        favoriteButtonPressed?()
    }
    
    private func addImage(image: UIImageView) {
        containerView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addLabel(label: UILabel, font: UIFont = Theme.defaultTheme.themeFont.bodyFont) {
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = font
        label.textColor = .white
    }
    
    func configure(with weatherInfo: WeatherInfo) {
        
        cityLabel.text = "\(weatherInfo.city)"
        countryLabel.text = "\(weatherInfo.country)"
        temperatureLabel.text = "\(weatherInfo.temperature)°"
        weatherDescriptionLabel.text = "\(weatherInfo.weatherDescription.rawValue.capitalized)"
        humidityLabel.text = "\(weatherInfo.humidity)%"
        windSpeedLabel.text = "\(weatherInfo.windSpeed) mph"
        
        updateFavoriteButton(for: weatherInfo)
        configureBackground(with: weatherInfo)
    }
    
    private func updateFavoriteButton(for weatherInfo: WeatherInfo) {
        favoriteButton.setImage(favoriteImage(for: weatherInfo), for: .normal)
    }
    
    private func favoriteImage(for weatherInfo: WeatherInfo) -> UIImage? {
        guard let favorites = loadFavorites() else { return SystemImages.favorite.normal }
        return favorites.contains(where: { $0.id == weatherInfo.id }) ? SystemImages.favorite.toSelected :SystemImages.favorite.normal
    }
    
    private func loadFavorites() -> WeatherData? {
        guard let data = UserDefaults.standard.data(forKey: "favorites") else { return nil }
        return try? JSONDecoder().decode(WeatherData.self, from: data)
    }
    
    private func configureBackground(with weatherInfo: WeatherInfo) {
        let backgroundImageName: String
        
        switch weatherInfo.weatherDescription {
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
        case .rain:
            backgroundImageName = "Rainy"
        }
        
        if let backgroundImage = UIImage(named: backgroundImageName) {
            backgroundImageView.image = backgroundImage
        }
    }
}

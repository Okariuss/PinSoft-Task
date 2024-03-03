//
//  WeatherForecastTableViewCell.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 3.03.2024.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let humidityImage = UIImageView(image: SystemImages.humidity.normal)
    private let humidityLabel = UILabel()
    private let windSpeedImage = UIImageView(image: SystemImages.wind.normal)
    private let windSpeedLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerViewConstraints()
        backgroundImageViewConstraints()
        labelsConstraints()
    }
    
    private func containerViewConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        containerView.layer.cornerRadius = AppConstants.RadiusConstants.high.rawValue
        containerView.layer.borderWidth = 1
        
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
        backgroundImageView.layer.cornerRadius = AppConstants.RadiusConstants.high.rawValue
        backgroundImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    private func labelsConstraints() {
        CommonComponents.addLabel(view: containerView, label: dateLabel, font: Theme.defaultTheme.themeFont.headlineFont)
        CommonComponents.addImage(view: containerView, image: humidityImage)
        CommonComponents.addImage(view: containerView, image: windSpeedImage)
        CommonComponents.addLabel(view: containerView, label: weatherDescriptionLabel)
        CommonComponents.addLabel(view: containerView, label: temperatureLabel, font: Theme.defaultTheme.themeFont.headerFont)
        CommonComponents.addLabel(view: containerView, label: humidityLabel)
        CommonComponents.addLabel(view: containerView, label: windSpeedLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppConstants.SpaceConstants.medium.rawValue),
            
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
    
    func configure(with forecast: Forecast) {
        dateLabel.text = "\(forecast.date)".formattedDate()
        temperatureLabel.text = "\(forecast.temperature)°C"
        weatherDescriptionLabel.text = "\(forecast.weatherDescription)"
        humidityLabel.text = "\(forecast.humidity)%"
        windSpeedLabel.text = "\(forecast.windSpeed) km/h"
        
        configureBackground(with: forecast)
    }
    
    private func configureBackground(with forecastInfo: Forecast) {
        let weatherCondition = WeatherCondition(rawValue: forecastInfo.weatherDescription.lowercased())
        let backgroundImageName: String
        
        switch weatherCondition {
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


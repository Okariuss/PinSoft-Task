# PinSoft iOS Weather App

## Overview

This app is a mobile application developed as part of the Pinsoft iOS Developer Case Study. It's designed to showcase proficiency in iOS mobile application development, emphasizing a clean, maintainable coding style while delivering a feature-rich, user-friendly experience. The app fetches weather data from a remote JSON source, displays it with pagination, and includes detailed views, search functionality, and a favourites feature, all while supporting offline usage.

## Features

- **Weather List Screen**: Displays a paginated list of weather details fetched from remote JSON data, including country, city, temperature, weather description, humidity, and wind speed.
- **Search Functionality**: Includes a search bar for filtering weather data by city.
- **Weather Details Screen**: Offers detailed weather information and a two-day forecast for the selected city.
- **Favourites Screen**: Allows users to add or remove cities from their favourites and view detailed weather data for these cities.
- **Offline Support**: Utilizes UserDefaults to cache weather data for offline viewing.
- **Internet Connectivity Check**: Employs NWPathMonitor to monitor internet connection status.
- **MVVM Architecture**: Adheres to the Model-View-ViewModel (MVVM) pattern to ensure a well-structured, maintainable codebase.

## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/Okariuss/PinSoft-Task.git
cd PinSoft-Task
```
Open the project in Xcode, build it, and run it on your chosen iOS simulator or physical device.

## Usage

- Use the search bar at the top of the Weather List Screen to find specific cities from given API
- Select a city to view detailed weather information and a two-day forecast.
- Add or remove cities from your favourites for quick access.

## Technologies I Used

- MVVM Pattern
- UIKit
- UserDefaults
- Network



https://github.com/Okariuss/PinSoft-Task/assets/73099263/043ead1d-53e0-4249-9e2c-85b8ebf5ae42



//
//  ContentViewModel.swift
//  ootd
//
//  Created by Gyuni on 11/23/24.
//

import Foundation
import Service
import WidgetKit
import WeatherKit
import MapKit

final class ContentViewModel: ObservableObject {
    private let userSettingsRepository = UserSettingsRepository.shared
    private let recommendationRepository = RecommendationRepository.shared
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    @Published var sex: Sex = .male
    @Published var situation: Situation = .casual
    @Published var stylePreference: StylePreference = .casual
    @Published var imageURL: URL?
    @Published var description: String?
    @Published var temperature: String = "11°C"
    @Published var humidity: String = "60%"
    @Published var isLoading: Bool = false
    
    init() {
        if let sex = userSettingsRepository.sex {
            self.sex = sex
        }
        if let situation = userSettingsRepository.situation {
            self.situation = situation
        }
        if let stylePreference = userSettingsRepository.stylePreference {
            self.stylePreference = stylePreference
        }
        if let imageURL = userSettingsRepository.imageURL {
            self.imageURL = URL(string: imageURL)
        }
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        refreshWeather()
    }

    func refreshWeather() {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: locManager.location ?? .init())
                DispatchQueue.main.async {
                    self.temperature = "\(Int(weather.currentWeather.temperature.value))°C"
                    self.humidity = "\(Int(weather.currentWeather.humidity * 100))%"
                }
            } catch {
                print(String(describing: error))
            }
        }
    }

    func fetchRecommendation() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let description = "temperature: \(temperature), humidity: \(humidity), sex: \(sex), situation: \(situation), stylePreference: \(stylePreference)"
        do {
            let response = try await recommendationRepository.fetchRecommendation(description: description)

            if let data = response.data(using: .utf8) {
                let recommendation = try JSONDecoder().decode(Recommendation.self, from: data)
                DispatchQueue.main.async {
                    self.imageURL = URL(string: recommendation.image)
                    self.description = recommendation.description
                    self.isLoading = false
                    
                    self.userSettingsRepository.imageURL = self.imageURL?.absoluteString
                    self.userSettingsRepository.sex = self.sex
                    self.userSettingsRepository.situation = self.situation
                    self.userSettingsRepository.stylePreference = self.stylePreference
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Failed to fetch recommendation")
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            print("Error fetching recommendation: \(error)")
        }
    }
}

//
//  WeatherManager.swift
import Foundation
import CoreLocation
import WeatherKit

@MainActor
final class WeatherManager {
    static let shared = WeatherManager()
    private let service = WeatherService.shared
    
    struct Snapshot {
        let city: String
        let country: String
        let temperatureC: Double
        let humidityPct: Int
        let asOf: Date
    }
    
    func fetchSnapshot(for location: CLLocation) async throws -> Snapshot {
        let weather = try await service.weather(for: location)
        let current = weather.currentWeather
        let humidity = Int(round(current.humidity * 100)) // 0.0...1.0
        let tempC = current.temperature.converted(to: .celsius).value
        
        // Reverse geocode for city/country label
        let placemarks = try await withCheckedThrowingContinuation { (cont: CheckedContinuation<[CLPlacemark], Error>) in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, err in
                if let err = err { cont.resume(throwing: err); return }
                cont.resume(returning: placemarks ?? [])
            }
        }
        let pm = placemarks.first
        let city = pm?.locality ?? "—"
        let country = pm?.country ?? pm?.isoCountryCode ?? "—"
        
        return Snapshot(city: city, country: country, temperatureC: tempC, humidityPct: humidity, asOf: Date())
    }
}

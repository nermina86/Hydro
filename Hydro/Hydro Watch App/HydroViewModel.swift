//
//  HydroViewModel.swift
//
import Foundation
import CoreLocation
import Combine
import SwiftUI

@MainActor
final class HydroViewModel: ObservableObject {
    @Published var city: String = "—"
  //  @Published var country: String = "—"
    @Published var tempC: Double = .nan
    @Published var humidity: Int = 0
    @Published var lastUpdated: Date?
    @Published var reminderCountPerDay: Int = UserDefaults.standard.integer(forKey: "reminders") == 0 ? 6 : UserDefaults.standard.integer(forKey: "reminders")
    
    @Published var exerciseBoostActive: Bool = false
    @Published var weatherBoostActive: Bool = false
    
    // MARK: - Hydration feedback
    @Published var hydrationMessage: String = "—"
    @Published var hydrationEmoji: String = "🌤"
    @Published var hydrationColor: Color = .blue
    
    func onAppear() {
        Task {
            LocationManager.shared.request()
            try? await HealthManager.shared.requestAuthorization()
            _ = await NotificationScheduler.requestAuth()
            await refreshWeatherIfPossible()
            observeExercise()
        }
    }
    
    func setReminders(_ count: Int) {
        reminderCountPerDay = max(1, min(count, 12))
        UserDefaults.standard.set(reminderCountPerDay, forKey: "reminders")
        reschedule()
    }
    
    /// Fetches live weather if possible, or provides fake simulator data for debugging.
    func refreshWeatherIfPossible() async {
        #if targetEnvironment(simulator)
        // 🧪 DEBUG: Provide fake simulator data for UI testing
        self.city = "Sarajevo"
      //  self.country = "Bosnia"
        self.tempC = Double.random(in: 22...31)
        self.humidity = Int.random(in: 45...75)
        self.lastUpdated = Date()
        evaluateHydrationNeed()
        print("🧪 Using fake weather: \(String(format: "%.1f", tempC))°C, \(humidity)% humidity")
        reschedule()
        return
        #else
        guard let loc = LocationManager.shared.location else { return }
        do {
            let snap = try await WeatherManager.shared.fetchSnapshot(for: loc)
            city = snap.city
          //country = snap.country
            tempC = snap.temperatureC
            humidity = snap.humidityPct
            lastUpdated = snap.asOf
            evaluateHydrationNeed()
            reschedule()
        } catch {
            print("⚠️ Weather fetch failed: \(error)")
        }
        #endif
    }
    
    /// Evaluates hydration need and sets emoji, color, and user message.
    private func evaluateHydrationNeed() {
        if tempC > 26 {
            weatherBoostActive = true
            hydrationEmoji = "☀️"
            hydrationColor = .red
            hydrationMessage = "It’s hot outside — drink extra water to stay cool."
        } else if tempC > 20 && humidity > 60 {
            weatherBoostActive = true
            hydrationEmoji = "💦"
            hydrationColor = .orange
            hydrationMessage = "It feels warm and humid — take a few sips to stay hydrated."
        } else {
            weatherBoostActive = false
            hydrationEmoji = "🌤"
            hydrationColor = .blue
            hydrationMessage = "Normal conditions — your regular water routine is fine."
        }
    }
    
    private func observeExercise() {
        // Tie boosts to HealthManager publishers
        Task.detached { [weak self] in
            for await _ in HealthManager.shared.$workoutActive.values {
                await MainActor.run {
                    self?.updateExerciseBoost()
                }
            }
        }
        Task.detached { [weak self] in
            for await _ in HealthManager.shared.$elevatedHR.values {
                await MainActor.run {
                    self?.updateExerciseBoost()
                }
            }
        }
    }
    
    private func updateExerciseBoost() {
        exerciseBoostActive = HealthManager.shared.workoutActive || HealthManager.shared.elevatedHR
        reschedule()
    }
    
    private func reschedule() {
        let bump = weatherBoostActive || exerciseBoostActive
        let plan = ReminderStrategy.buildPlan(count: reminderCountPerDay, bump: bump)
        NotificationScheduler.scheduleDaily(plan: plan)
    }
}


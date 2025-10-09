//
//  HydroViewModel.swift
import Foundation
import CoreLocation
import Combine


@MainActor
final class HydroViewModel: ObservableObject {
    @Published var city: String = "—"
    @Published var country: String = "—"
    @Published var tempC: Double = .nan
    @Published var humidity: Int = 0
    @Published var lastUpdated: Date?
    @Published var reminderCountPerDay: Int = UserDefaults.standard.integer(forKey: "reminders") == 0 ? 6 : UserDefaults.standard.integer(forKey: "reminders")
    
    @Published var exerciseBoostActive: Bool = false
    @Published var weatherBoostActive: Bool = false
    
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
    
    func refreshWeatherIfPossible() async {
        guard let loc = LocationManager.shared.location else { return }
        do {
            let snap = try await WeatherManager.shared.fetchSnapshot(for: loc)
            city = snap.city
            country = snap.country
            tempC = snap.temperatureC
            humidity = snap.humidityPct
            lastUpdated = snap.asOf
            weatherBoostActive = (tempC >= 26) || (humidity >= 65)
            reschedule()
        } catch { }
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

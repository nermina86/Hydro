//
//  HealthManager.swift
//  Hydro Watch App
//

import Foundation
import HealthKit
import Combine

final class HealthManager: ObservableObject {
    static let shared = HealthManager()
    private let store = HKHealthStore()
    
    @Published var workoutActive: Bool = false
    @Published var elevatedHR: Bool = false
    
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    private let workoutType = HKObjectType.workoutType()
    
    // MARK: - Authorization
    func requestAuthorization() async throws {
        try await store.requestAuthorization(toShare: [], read: [heartRateType, workoutType])
        startWorkoutObserver()
        startHeartRateStreaming()
    }
    
    // MARK: - Workout Observer
    private func startWorkoutObserver() {
        let query = HKObserverQuery(sampleType: workoutType, predicate: nil) { [weak self] _, _, error in
            guard error == nil else { return }
            self?.checkOngoingWorkout()
        }
        
        store.execute(query)
        checkOngoingWorkout()
    }
    
    private func checkOngoingWorkout() {
        let predicate = HKQuery.predicateForSamples(
            withStart: Date().addingTimeInterval(-3 * 60 * 60),
            end: nil,
            options: .strictStartDate
        )
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { [weak self] _, samples, _ in
            let isActive = (samples as? [HKWorkout])?
                .contains(where: { $0.endDate == $0.startDate }) ?? false
            
            DispatchQueue.main.async {
                self?.workoutActive = isActive
            }
        }
        
        store.execute(query)
    }
    
    // MARK: - Heart Rate Streaming
    private func startHeartRateStreaming() {
        let predicate = HKQuery.predicateForSamples(
            withStart: Date().addingTimeInterval(-30 * 60),
            end: nil,
            options: .strictStartDate
        )
        
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, _ in
            self?.evaluateHR(samples)
        }
        
        query.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.evaluateHR(samples)
        }
        
        store.execute(query)
    }
    
    // MARK: - Evaluate Heart Rate
    private func evaluateHR(_ samples: [HKSample]?) {
        guard let hrSamples = samples as? [HKQuantitySample] else { return }
        
        // Simple heuristic: BPM > 120 recently => elevated
        let now = Date()
        let recent = hrSamples.filter {
            now.timeIntervalSince($0.endDate) < 10 * 60 // last 10 minutes
        }
        
        let bpmValues = recent.map {
            $0.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        }
        
        let elevated = (bpmValues.max() ?? 0) > 120
        
        DispatchQueue.main.async {
            self.elevatedHR = elevated
        }
    }
}


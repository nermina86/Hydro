//
//  HapticManager.swift
import WatchKit

enum HapticType {
    case hydrationReminder
    case goalAchieved
}

struct HapticManager {
    static func play(_ type: HapticType) {
        switch type {
        case .hydrationReminder:
            WKInterfaceDevice.current().play(.directionUp)
        case .goalAchieved:
            WKInterfaceDevice.current().play(.success)
        }
    }
}

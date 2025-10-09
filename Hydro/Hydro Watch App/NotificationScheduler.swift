//
//  NotificationScheduler.swift
import Foundation
import UserNotifications

struct ReminderPlan {
    let times: [DateComponents] // hour/minute pairs today
}

enum ReminderStrategy {
    static func buildPlan(count: Int, startHour: Int = 8, endHour: Int = 22, bump: Bool) -> ReminderPlan {
        let span = endHour - startHour
        let slots = max(1, count)
        let step = Double(span) / Double(slots)
        var comps: [DateComponents] = []
        for i in 0..<slots {
            let hour = Int(round(Double(startHour) + step * Double(i)))
            comps.append(.init(hour: hour, minute: 0))
        }
        if bump {
            comps.append(.init(hour: min(21, startHour + span/2 + 2), minute: 30))
        }
        return ReminderPlan(times: comps)
    }
}

enum NotificationScheduler {
    static func requestAuth() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted ?? false
    }
    
    static func scheduleDaily(plan: ReminderPlan) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        for (idx, t) in plan.times.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Hydro"
            content.body = "Sip some water 💧"
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: t, repeats: true)
            let req = UNNotificationRequest(identifier: "hydro-\(idx)", content: content, trigger: trigger)
            center.add(req)
        }
    }
}

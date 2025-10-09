//
//  PermissionsView.swift
import SwiftUI
import UserNotifications

struct PermissionsView: View {
    @State private var notifStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        List {
            Label("Location: Used to fetch local weather.", systemImage: "location")
            Label("Health: Detect workouts & elevated heart rate.", systemImage: "heart.fill")
            Label("Notifications: Schedule drink reminders.", systemImage: "bell")
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { s in
                notifStatus = s.authorizationStatus
            }
        }
    }
}

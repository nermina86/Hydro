//
//  HydroApp.swift
//  Hydro Watch App
//

import SwiftUI

@main
struct HydroApp: App {
    @StateObject private var vm = HydroViewModel() // shared view model for the entire app

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView(vm: vm) // pass the same instance
            }
        }
    }
}

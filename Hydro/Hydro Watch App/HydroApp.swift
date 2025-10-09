//
//  HydroApp.swift
//  Hydro Watch App
//

// HydroApp.swift

import SwiftUI

@main
struct HydroApp: App {
    @StateObject private var vm = HydroViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView(vm: vm)
            }
        }
    }
}

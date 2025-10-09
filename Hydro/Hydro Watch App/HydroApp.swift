//
//  HydroApp.swift
//  Hydro Watch App
//
//  Created by Mina Memisevic on 9. 10. 2025..
//

import SwiftUI

@main
struct HydroApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView()
            }
        }
    }
}

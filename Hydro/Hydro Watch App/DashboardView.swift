//
//  DashboardView.swift
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var vm: HydroViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text("Hydro")
                .font(.headline)
            Text("\(vm.city), \(vm.country)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                stat("Temp", value: vm.tempC.isNaN ? "—" : String(format: "%.0f℃", vm.tempC))
                stat("Humidity", value: "\(vm.humidity)%")
            }

            // 💧 Hydration feedback (emoji, color & message)
            if !vm.hydrationMessage.isEmpty && vm.hydrationMessage != "—" {
                Text("\(vm.hydrationEmoji) \(vm.hydrationMessage)")
                    .foregroundColor(vm.hydrationColor)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .transition(.opacity)
                    .id(vm.hydrationMessage) // ensures view updates when text changes
            }

            // 💦 Optional: Show simple reminder badge when extra boosts active
            if vm.weatherBoostActive || vm.exerciseBoostActive {
                Label("Extra reminders active", systemImage: "drop.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)
                    .padding(.top, 2)
            }

            // 🔄 Update button
            Button {
                Task { await vm.refreshWeatherIfPossible() }
            } label: {
                Label("Update now", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
            .font(.caption)

            // ⚙️ Settings navigation
            NavigationLink("Settings") {
                SettingsView(vm: vm)
            }
            .font(.caption)
        }
        .padding()
        .onAppear {
            vm.onAppear()
        }
        // Smoothly animate hydration message changes
        .animation(.easeInOut(duration: 0.4), value: vm.hydrationMessage)
    }

    func stat(_ title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.title2).bold()
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardView(vm: HydroViewModel())
}

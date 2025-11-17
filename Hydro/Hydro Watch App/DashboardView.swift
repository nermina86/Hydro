//
//  DashboardView.swift
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var vm: HydroViewModel

    var body: some View {
        // Use ScrollView so long text never clips
        ScrollView {
            VStack(spacing: 8) {
                Text("Hydro: \(vm.city)")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(.secondary)

                HStack {
                    stat("Temp", value: vm.tempC.isNaN ? "—" : String(format: "%.0f℃", vm.tempC))
                    stat("Humidity", value: "\(vm.humidity)%")
                }

                // 💧 Hydration feedback (emoji + text + color)
                if !vm.hydrationMessage.isEmpty && vm.hydrationMessage != "—" {
                    Text("\(vm.hydrationEmoji) \(vm.hydrationMessage)")
                        .foregroundColor(vm.hydrationColor)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 8)
                        .transition(.opacity)
                        .id(vm.hydrationMessage)
                }

                // 💦 Optional status label
                if vm.weatherBoostActive || vm.exerciseBoostActive {
                    Label("Extra reminders active", systemImage: "drop.fill")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                        .padding(.top, 2)
                }

                // 📚 Citation hint for App Review & users
                Text("Hydration guidance is based on public health sources (Mayo Clinic, NHS). See Settings → Sources.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)

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
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            vm.onAppear()
        }
        .animation(.easeInOut(duration: 0.3), value: vm.hydrationMessage)
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

//
//  SettingsView.swift
//  Hydro Watch App
//

import SwiftUI
import WatchKit

struct SettingsView: View {
    @ObservedObject var vm: HydroViewModel

    var body: some View {
        Form {
            // MARK: - Reminders per day
            Section {
                Stepper(
                    value: Binding(
                        get: { vm.reminderCountPerDay },
                        set: { newValue in
                            vm.setReminders(newValue)
                            WKInterfaceDevice.current().play(.click)
                        }
                    ),
                    in: 1...12
                ) {
                    Text("\(vm.reminderCountPerDay)× / day")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut, value: vm.reminderCountPerDay)
                }
                .labelsHidden() // hides default Stepper label
            } header: {
                Text("Reminders per day")
                    .font(.footnote)
            }

            // MARK: - Info Section
            Section {
                Text("We’ll add extra reminder to drink water when it’s hot, or you exercise.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 2)
            }

            // MARK: - Permissions Section
            Section {
                NavigationLink("Permissions") {
                    PermissionsView()
                }
                .font(.footnote)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(vm: HydroViewModel())
}


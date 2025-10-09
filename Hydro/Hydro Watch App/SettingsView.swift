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
                HStack(spacing: 22) {
                    Button(action: {
                        if vm.reminderCountPerDay > 1 {
                            vm.setReminders(vm.reminderCountPerDay - 1)
                            WKInterfaceDevice.current().play(.click)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                    }
                    .tint(.gray)

                    Text("\(vm.reminderCountPerDay)× / day")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(minWidth: 80)
                        .animation(.easeInOut, value: vm.reminderCountPerDay)

                    Button(action: {
                        if vm.reminderCountPerDay < 12 {
                            vm.setReminders(vm.reminderCountPerDay + 1)
                            WKInterfaceDevice.current().play(.click)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                    }
                    .tint(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            } header: {
                Text("Reminders per day")
                    .font(.footnote)
            }

            // MARK: - Info Section
            Section {
                Text("We’ll auto-add one extra reminder when it’s hot, humid, or you’re exercising.")
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
    // Preview with a mock view model
    SettingsView(vm: HydroViewModel())
}


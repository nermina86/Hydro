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
            
            // MARK: - Sources & Permissions Section
            Section {
                NavigationLink("Sources") {
                    SourcesView()
                }

                NavigationLink("Permissions") {
                    PermissionsView()
                }
                
                NavigationLink("Disclaimer") {
                    DisclaimerView()
                }
                
            }
            .font(.footnote)
            
            // MARK: - Notification window
            Section {
                HStack {
                    Text("From")
                        .font(.caption2)
                    Spacer()
                    Picker("From", selection: Binding(
                        get: { vm.startHour },
                        set: { vm.setStartHour($0) }
                    )) {
                        ForEach(6...20, id: \.self) { hour in
                            Text(String(format: "%02d:00", hour))
                                .tag(hour)
                        }
                    }
                    .labelsHidden()
                }

                HStack {
                    Text("To")
                        .font(.caption2)
                    Spacer()
                    Picker("To", selection: Binding(
                        get: { vm.endHour },
                        set: { vm.setEndHour($0) }
                    )) {
                        ForEach(7...23, id: \.self) { hour in
                            Text(String(format: "%02d:00", hour))
                                .tag(hour)
                        }
                    }
                    .labelsHidden()
                }
            } header: {
                Text("Notification window")
                    .font(.footnote)
            } footer: {
                Text("Hydration reminders will only be scheduled between these times.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            // MARK: - Info Section
            Section {
                Text("We’ll add an extra reminder to drink water when it’s hot, or when exercise mode is detected.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 2)
            }

        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(vm: HydroViewModel())
}

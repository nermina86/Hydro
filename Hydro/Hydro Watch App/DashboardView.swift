//
//  DashboardView.swift
import SwiftUI

struct DashboardView: View {
    @StateObject private var vm = HydroViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Hydro").font(.headline)
            Text("\(vm.city), \(vm.country)").font(.caption).foregroundStyle(.secondary)
            
            HStack {
                stat("Temp", value: vm.tempC.isNaN ? "—" : String(format: "%.0f℃", vm.tempC))
                stat("Humidity", value: "\(vm.humidity)%")
            }
            
            if vm.weatherBoostActive || vm.exerciseBoostActive {
                Label("Extra reminders active", systemImage: "drop.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)
            }
            
            Button {
                Task { await vm.refreshWeatherIfPossible() }
            } label: {
                Label("Update now", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
            .font(.caption)
            
            NavigationLink("Settings", destination: SettingsView(vm: vm))
                .font(.caption)
        }
        .padding()
        .onAppear {
            vm.onAppear()
            Task { await vm.refreshWeatherIfPossible() }
            
                }
        
        
    }
    
    func stat(_ title: String, value: String) -> some View {
        VStack {
            Text(value).font(.title2).bold()
            Text(title).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    

    
}


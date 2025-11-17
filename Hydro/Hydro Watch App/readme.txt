Hydration/
│
├── Hydration Watch App/
│   ├── DashboardView.swift              → Displays current weather, humidity, and hydration status
│   ├── SettingsView.swift               → Lets user set number of daily reminders
│   ├── HydroViewModel.swift             → Core logic for weather, hydration, reminders
│   ├── HealthManager.swift              → Handles HealthKit authorization + workout monitoring
│   ├── LocationManager.swift            → Fetches user’s current coordinates
│   ├── WeatherManager.swift             → Uses WeatherKit / coordinates to get temperature + humidity
│   ├── NotificationScheduler.swift      → Schedules reminder notifications on the Watch
│   ├── ReminderStrategy.swift           → Builds daily reminder timing logic based on weather & activity
│   ├── Assets.xcassets/                 → App icons and color assets
│   ├── Preview Content/
│   │   └── Preview Assets.xcassets/     → Placeholder assets for SwiftUI previews
│   └── Info.plist                       → App configuration (permissions, capabilities)
│
├── Shared/
│   ├── Models/
│   │   └── Common types (e.g. ReminderPlan, WeatherSnapshot)
│   ├── Managers/
│   │   └── Shared utility classes (HealthManager, LocationManager)
│
├── Hydro.xcodeproj/                     → Xcode project definition
│
└── README.txt                           → Documentation


 Quick Hydration Coach
* Shows your current water intake progress on the watch face complication.
* Uses weather + heart rate + step count to suggest how much you need today (instead of generic “2 liters”).
* Sends gentle haptics if you’re behind on hydration goals.
* Why missing: Water reminder apps exist, but none adapt goals to your actual day’s activity, hearth rate + climate.

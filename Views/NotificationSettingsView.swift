//
//  NotificationSettingsView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 5.01.2026.
//

import SwiftUI

struct NotificationSettingsView: View {

    // Default: haftalık
    @AppStorage("notif_frequency") private var frequencyRaw: String = NotificationFrequency.weekly.rawValue
    @AppStorage("notif_hour") private var hour: Int = 21
    @AppStorage("notif_minute") private var minute: Int = 0
    @AppStorage("notif_weekday") private var weekday: Int = 2 // Pazartesi

    private var frequency: NotificationFrequency {
        get { NotificationFrequency(rawValue: frequencyRaw) ?? .weekly }
        set { frequencyRaw = newValue.rawValue }
    }

    private let weekdayNames: [(Int, String)] = [
        (2, "Pazartesi"),
        (3, "Salı"),
        (4, "Çarşamba"),
        (5, "Perşembe"),
        (6, "Cuma"),
        (7, "Cumartesi"),
        (1, "Pazar")
    ]

    var body: some View {
        Form {
            Section("Sıklık") {
                Picker("Bildirim", selection: Binding(
                    get: { frequency },
                    set: { newValue in
                        frequencyRaw = newValue.rawValue
                        applySchedule()
                    }
                )) {
                    ForEach(NotificationFrequency.allCases) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
            }

            if frequency != .none {
                Section("Saat") {
                    DatePicker(
                        "Bildirim Saati",
                        selection: Binding(
                            get: {
                                Calendar.current.date(
                                    bySettingHour: hour,
                                    minute: minute,
                                    second: 0,
                                    of: Date()
                                ) ?? Date()
                            },
                            set: { date in
                                hour = Calendar.current.component(.hour, from: date)
                                minute = Calendar.current.component(.minute, from: date)
                                applySchedule()
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            if frequency == .weekly {
                Section("Gün") {
                    Picker("Gün", selection: Binding(
                        get: { weekday },
                        set: { newValue in
                            weekday = newValue
                            applySchedule()
                        }
                    )) {
                        ForEach(weekdayNames, id: \.0) { (value, name) in
                            Text(name).tag(value)
                        }
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    frequencyRaw = NotificationFrequency.none.rawValue
                    NotificationManager.shared.removeReminder()
                } label: {
                    Text("Hatırlatıcıyı Kapat")
                }
            }
        }
        .navigationTitle("Okuma Hatırlatmaları")
        .task {
            // Bu ekran açılınca izin iste
            _ = await NotificationManager.shared.requestPermission()

            // İzin verildiyse mevcut ayara göre schedule et
            applySchedule()
        }
    }

    private func applySchedule() {
        let f = NotificationFrequency(rawValue: frequencyRaw) ?? .weekly
        NotificationManager.shared.scheduleReminder(
            frequency: f,
            hour: hour,
            minute: minute,
            weekday: weekday
        )
    }
}

//
//  NotificationManager.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 5.01.2026.
//

import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    private let identifier = "readingReminder"

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error:", error)
            return false
        }
    }

    func removeReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func scheduleReminder(
        frequency: NotificationFrequency,
        hour: Int,
        minute: Int,
        weekday: Int = 2 // 1=Pazar ... 7=Cumartesi | default: Pazartesi
    ) {
        // Önce eskisini temizle
        removeReminder()

        guard frequency != .none else { return }

        let content = UNMutableNotificationContent()
        content.title = "📚 Okuma Zamanı"
        content.body = "Bugün birkaç sayfa okumaya ne dersin?"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        switch frequency {
        case .daily:
            break
        case .weekly:
            comps.weekday = weekday
        case .none:
            return
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Schedule error:", error)
            }
        }
    }
}

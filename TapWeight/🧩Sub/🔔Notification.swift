import UserNotifications

struct 🔔Notification {
    private let ⓐpi = UNUserNotificationCenter.current()
    
    func clearBadge() {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = 0
        self.ⓐpi.add(UNNotificationRequest(identifier: "resetBadge", content: ⓒontent, trigger: nil))
    }
}

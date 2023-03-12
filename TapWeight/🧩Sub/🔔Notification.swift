import UserNotifications

struct 🔔Notification {
    static let api = UNUserNotificationCenter.current()
    
    static func ⓡemoveAllNotifications() {
        Self.api.removeAllDeliveredNotifications()
        Self.api.removeAllPendingNotificationRequests()
        Self.ⓒlearBadge()
    }
    
    static private func ⓒlearBadge() {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = 0
        Self.api.add(UNNotificationRequest(identifier: "resetBadge", content: ⓒontent, trigger: nil))
    }
    
    static func ⓢetBadgeNow(_ ⓒount: Int) {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = ⓒount as NSNumber
        let ⓡequest = UNNotificationRequest(identifier: "badge" + ⓒount.description,
                                            content: ⓒontent,
                                            trigger: nil)
        Self.api.add(ⓡequest)
    }
}

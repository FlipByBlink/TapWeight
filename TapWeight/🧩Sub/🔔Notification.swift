import UserNotifications

struct 🔔Notification {
    let api = UNUserNotificationCenter.current()
    
    func ⓡemoveAllNotifications() {
        self.api.removeAllDeliveredNotifications()
        self.api.removeAllPendingNotificationRequests()
        self.ⓒlearBadge()
    }
    
    private func ⓒlearBadge() {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = 0
        self.api.add(UNNotificationRequest(identifier: "resetBadge", content: ⓒontent, trigger: nil))
    }
    
    func ⓢetBadgeNow(_ ⓒount: Int) {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = ⓒount as NSNumber
        let ⓡequest = UNNotificationRequest(identifier: "badge" + ⓒontent.description,
                                            content: ⓒontent,
                                            trigger: nil)
        self.api.add(ⓡequest)
    }
}

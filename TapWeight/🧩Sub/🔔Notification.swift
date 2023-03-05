import UserNotifications

struct 🔔Notification {
    private let ⓐpi = UNUserNotificationCenter.current()
    
    func removeAllNotifications() {
        self.ⓐpi.removeAllDeliveredNotifications()
        self.ⓐpi.removeAllPendingNotificationRequests()
        self.clearBadge()
    }
    
    func clearBadge() {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = 0
        self.ⓐpi.add(UNNotificationRequest(identifier: "resetBadge", content: ⓒontent, trigger: nil))
    }
    
    func setBadge(_ ⓒount: Int) {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = ⓒount as NSNumber
        let ⓡequest = UNNotificationRequest(identifier: "badge" + ⓒontent.description,
                                            content: ⓒontent,
                                            trigger: nil)
        self.ⓐpi.add(ⓡequest)
    }
    
    func add(_ ⓡequest: UNNotificationRequest) {
        self.ⓐpi.add(ⓡequest)
    }
}

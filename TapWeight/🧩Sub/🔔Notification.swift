import UserNotifications

struct 🔔Notification {
    let api = UNUserNotificationCenter.current()
    
    func removeAllNotifications() {
        self.api.removeAllDeliveredNotifications()
        self.api.removeAllPendingNotificationRequests()
        self.clearBadge()
    }
    
    private func clearBadge() {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = 0
        self.api.add(UNNotificationRequest(identifier: "resetBadge", content: ⓒontent, trigger: nil))
    }
    
    func setBadgeNow(_ ⓒount: Int) {
        let ⓒontent = UNMutableNotificationContent()
        ⓒontent.badge = ⓒount as NSNumber
        let ⓡequest = UNNotificationRequest(identifier: "badge" + ⓒontent.description,
                                            content: ⓒontent,
                                            trigger: nil)
        self.api.add(ⓡequest)
    }
    
    func checkAuthDenied() async -> Bool {
        await self.api.notificationSettings().authorizationStatus == .denied
    }
}

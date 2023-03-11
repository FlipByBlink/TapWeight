import SwiftUI
import HealthKit
import WatchConnectivity

extension 📱AppModel: UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.🔔notification.api.delegate = self
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        self.ⓡequestAuth([.bodyMass])
        
        self.ⓞbserveChanges()
        
        return true
    }
}

extension 📱AppModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .list, .badge, .sound]
    }
}

extension 📱AppModel {
    func 🔔setupNotification() {
        Task {
            try await self.🔔notification.api.requestAuthorization(options: [.badge, .alert, .sound])
            try await self.🏥healthStore.enableBackgroundDelivery(for: .bodyMass)
            await self.🔔refreshNotification()
        }
    }
    func 🔔refreshNotification() async {
        let ⓢample = await self.🏥healthStore.ⓛoadLatestSample(.bodyMass)
        self.🔔notification.removeAllNotifications()
        guard let ⓢample, self.🚩ableReminder else { return }
        let ⓟeriodToNow = Int(ⓢample.startDate.distance(to: .now) / (60 * 60 * 24))
        if ⓟeriodToNow >= self.🔢periodOfNonDisplay {
            self.🔔notification.setBadgeNow(ⓟeriodToNow)
        }
        for ⓒount in self.🔢periodOfNonDisplay...50 {
            let ⓐlertTime = ⓢample.startDate.addingTimeInterval(Double(60 * 60 * 24 * ⓒount))
            let ⓣimeInterval = Date.now.distance(to: ⓐlertTime)
            guard ⓣimeInterval > 0 else { continue }
            let ⓒontent = UNMutableNotificationContent()
            ⓒontent.badge = ⓒount as NSNumber
            if self.🚩ableBannerNotification {
                ⓒontent.title = "Reminder: \(String(localized: "Body Mass"))"
                let ⓕormatter = DateComponentsFormatter()
                ⓕormatter.allowedUnits = [.day]
                ⓒontent.body = "Passed \(ⓕormatter.string(from: Double(60 * 60 * 24 * ⓒount)) ?? "🐛")."
                ⓒontent.sound = .default
            }
            let ⓣrigger = UNTimeIntervalNotificationTrigger(timeInterval: ⓣimeInterval, repeats: false)
            let ⓡequest = UNNotificationRequest(identifier: ⓒount.description,
                                                content: ⓒontent,
                                                trigger: ⓣrigger)
            try? await self.🔔notification.api.add(ⓡequest)
        }
    }
    func checkAlertAboutAuthDenied() async -> Bool {
        guard self.🚩ableReminder else { return false }
        let ⓢetting = await self.🔔notification.api.notificationSettings()
        return ⓢetting.authorizationStatus == .denied
    }
}

extension 📱AppModel: WCSessionDelegate {
    //MARK: Required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        self.ⓒontext.sync()
    }
    //MARK: Required
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Nothing to do.
    }
    //MARK: Required
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}

extension 📱AppModel {
    var ⓒontext: 🄲ontext {
        🄲ontext(amount50g: self.🚩amount50g,
                 ableBMI: self.🚩ableBMI,
                 ableBodyFat: self.🚩ableBodyFat,
                 ableLBM: self.🚩ableLBM)
    }
}

extension 📱AppModel {
    var ⓣemporaryMassQuantity: HKQuantity {
        if let ⓜassUnit {
            switch ⓜassUnit {
                case .gramUnit(with: .kilo): return HKQuantity(unit: ⓜassUnit, doubleValue: 60.0)
                case .pound(): return HKQuantity(unit: ⓜassUnit, doubleValue: 130.0)
                case .stone(): return HKQuantity(unit: ⓜassUnit, doubleValue: 10.0)
                default: return HKQuantity(unit: ⓜassUnit, doubleValue: 0.0)
            }
        } else {
            return HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 0.0)
        }
    }
}

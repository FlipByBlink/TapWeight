import SwiftUI
import WatchConnectivity

extension 📱AppModel: UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.🔔notification.api.delegate = self
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        return true
    }
}

extension 📱AppModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .list, .badge, .sound]
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
                 ableLBM: self.🚩ableLBM,
                 massKilogramValue: self.📦latestSamples[.bodyMass]?.quantity.doubleValue(for: .gramUnit(with: .kilo)),
                 heightMeterValue: self.📦latestSamples[.height]?.quantity.doubleValue(for: .meter()),
                 bodyFatValue: self.📦latestSamples[.bodyFatPercentage]?.quantity.doubleValue(for: .count()))
    }
}



import SwiftUI
import WatchConnectivity

extension 📱AppModel: WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        self.ⓞbserveHealthKitChanges()
        self.ⓐddICloudObserver()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        self.ⓐpplyStoredContext()
    }
}

extension 📱AppModel {
    var ⓢtoredContext: 🄲ontext? { .iCloudKVS ?? .wcApplicationContext }
    func ⓐpplyStoredContext() {
        if let ⓢtoredContext {
            self.ⓐpplyContext(ⓢtoredContext)
        } else {
            print("🖨️ StoredContext is nothing.")
        }
    }
    func ⓐpplyContext(_ ⓒontext: 🄲ontext) {
        withAnimation {
            self.🚩ableBMI = ⓒontext.ableBMI
            self.🚩ableBodyFat = ⓒontext.ableBodyFat
            self.🚩ableLBM = ⓒontext.ableLBM
            self.🚩amount50g = ⓒontext.amount50g
            self.📦latestSamples = ⓒontext.latestHKQuantitySamples
            self.📝resetInputValues()
        }
    }
    private func ⓐddICloudObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ⓤbiquitousKeyValueStoreDidChange(_:)),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
    }
    @objc
    private func ⓤbiquitousKeyValueStoreDidChange(_ notification: Notification) {
        //Publishing changes from background threads is not allowed
        Task { @MainActor in
            self.ⓐpplyStoredContext()
        }
    }
}

extension 📱AppModel {
    func ⓡequestAuths() {
        var ⓡequestCategories: Set<🏥Category> = []
        if self.🏥healthStore.authorizationStatus(for: .bodyMass) == .notDetermined {
            ⓡequestCategories.insert(.bodyMass)
        }
        if self.🚩ableBMI {
            if self.🏥healthStore.authorizationStatus(for: .bodyMassIndex) == .notDetermined {
                ⓡequestCategories.insert(.bodyMassIndex)
            }
        }
        if self.🚩ableBodyFat {
            if self.🏥healthStore.authorizationStatus(for: .bodyFatPercentage) == .notDetermined {
                ⓡequestCategories.insert(.bodyFatPercentage)
            }
        }
        if self.🚩ableLBM {
            if self.🏥healthStore.authorizationStatus(for: .leanBodyMass) == .notDetermined {
                ⓡequestCategories.insert(.leanBodyMass)
            }
        }
        if !ⓡequestCategories.isEmpty {
            self.ⓡequestAuth(ⓡequestCategories)
        }
    }
}

extension 📱AppModel: WCSessionDelegate {
    //Required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            self.ⓐpplyStoredContext()
        }
    }
    //Optional
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        Task { @MainActor in
            if let ⓒontext = 🄲ontext.decode(applicationContext) {
                self.ⓐpplyContext(ⓒontext)
            } else {
                assertionFailure()
            }
        }
    }
}

//MARK: Purpose of debugging
extension 📱AppModel {
    var 🏥earliestPermittedSampleDate: String {
        #function + self.🏥healthStore.api.earliestPermittedSampleDate().formatted()
        //Almost 1 week ago on Apple Watch
    }
}

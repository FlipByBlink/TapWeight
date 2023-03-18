import SwiftUI
import WatchConnectivity

extension 📱AppModel {
    func ⓢetup() {
        self.ⓞbserveHealthKitChanges() //Observe bodymass-unit and height-unit only
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension 📱AppModel: WCSessionDelegate {
    //Required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            self.ⓐpplyStoredContext()
            self.ⓐddICloudObserver()
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

extension 📱AppModel {
    var ⓢtoredContext: 🄲ontext? { .wcApplicationContext ?? .iCloudKVS }
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
        //NotificationCenter call selector-function just after adding-observer too.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ⓤbiquitousKeyValueStoreDidChange(_:)),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
    }
    @objc
    private func ⓤbiquitousKeyValueStoreDidChange(_ notification: Notification) {
        //Publishing changes from background threads is not allowed.
        Task { @MainActor in
            if WCSession.default.activationState != .activated {
                self.ⓐpplyStoredContext()
            }
        }
    }
}

extension 📱AppModel {
    func ⓡequestAuths() {
        var ⓢhareSuggestions: Set<🏥Category> = [.bodyMass]
        var ⓡeadSuggestions: Set<🏥Category> = [.bodyMass]
        if self.🚩ableBMI {
            ⓢhareSuggestions.insert(.bodyMassIndex)
            ⓡeadSuggestions.insert(.height)
        }
        if self.🚩ableBodyFat { ⓢhareSuggestions.insert(.bodyFatPercentage) }
        if self.🚩ableLBM { ⓢhareSuggestions.insert(.leanBodyMass) }
        if !ⓢhareSuggestions.isEmpty || !ⓡeadSuggestions.isEmpty {
            self.ⓢuggestAuthRequest(toShare: ⓢhareSuggestions, read: ⓡeadSuggestions)
        }
    }
}

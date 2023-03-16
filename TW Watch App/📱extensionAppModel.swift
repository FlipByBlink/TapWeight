import SwiftUI
//import WatchConnectivity

extension 📱AppModel: WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        self.ⓞbserveHealthKitChanges()
        self.ⓘmportContext()
        self.ⓐddICloudObserver()
        //if WCSession.isSupported() {
        //    WCSession.default.delegate = self
        //    WCSession.default.activate()
        //}
    }
}

extension 📱AppModel {
    var ⓡeceivedContext: 🄲ontext? { 🄲ontext.iCloudKVS }
    func ⓘmportContext() {
        if let ⓡeceivedContext {
            withAnimation {
                self.🚩ableBMI = ⓡeceivedContext.ableBMI
                self.🚩ableBodyFat = ⓡeceivedContext.ableBodyFat
                self.🚩ableLBM = ⓡeceivedContext.ableLBM
                self.🚩amount50g = ⓡeceivedContext.amount50g
                self.📦latestSamples = ⓡeceivedContext.latestHKQuantitySamples
                self.📝resetInputValues()
            }
        } else {
            print("🖨️ iCloudKVS is nothing.")
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
            self.ⓘmportContext()
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

//extension 📱AppModel: WCSessionDelegate {
//    //Required
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        //Nothing to do.
//    }
//
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        self.ⓗandleContextDictionary(applicationContext)
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        self.ⓗandleContextDictionary(message)
//    }
//
//    private func ⓗandleContextDictionary(_ ⓓictionary: [String : Any]) {
//        Task { @MainActor in
//            if let ⓒontext = 🄲ontext.receive(ⓓictionary) {
//                withAnimation {
//                    self.🚩ableBMI = ⓒontext.ableBMI
//                    self.🚩ableBodyFat = ⓒontext.ableBodyFat
//                    self.🚩ableLBM = ⓒontext.ableLBM
//                    self.🚩amount50g = ⓒontext.amount50g
//                }
//            } else {
//                assertionFailure()
//            }
//        }
//    }
//}

//MARK: Purpose of debugging
extension 📱AppModel {
    var 🏥earliestPermittedSampleDate: String {
        #function + self.🏥healthStore.api.earliestPermittedSampleDate().formatted()
        //Almost 1 week ago on Apple Watch
    }
}

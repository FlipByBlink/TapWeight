import SwiftUI
import WatchConnectivity

extension 📱AppModel: WKApplicationDelegate {
    func applicationDidBecomeActive() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        self.ⓞbserveChanges()
    }
}

extension 📱AppModel: WCSessionDelegate {
    //Required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Nothing to do.
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("🖨️", #function, applicationContext.description)
        Task { @MainActor in
            if let ⓓata = applicationContext["ⓒontext"] as? Data {
                if let ⓒontext = 🄲ontext.receive(ⓓata) {
                    withAnimation {
                        self.🚩ableBMI = ⓒontext.ableBMI
                        self.🚩ableBodyFat = ⓒontext.ableBodyFat
                        self.🚩ableLBM = ⓒontext.ableLBM
                        self.🚩amount50g = ⓒontext.amount50g
                    }
                } else {
                    assertionFailure()
                }
            } else {
                assertionFailure()
            }
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

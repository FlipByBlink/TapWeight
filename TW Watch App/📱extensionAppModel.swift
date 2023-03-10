import SwiftUI
import WatchConnectivity

extension 📱AppModel: WKApplicationDelegate {
    func applicationDidBecomeActive() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension 📱AppModel: WCSessionDelegate {
    //MARK: Required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Nothing to do.
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("🖨️", #function, applicationContext.description)
        Task { @MainActor in
            if let ⓓata = applicationContext["ⓒontext"] as? Data {
                if let ⓒontext = 🄲ontext.receive(ⓓata) {
                    self.🚩ableBMI = ⓒontext.ableBMI
                    self.🚩ableBodyFat = ⓒontext.ableBodyFat
                    self.🚩ableLBM = ⓒontext.ableLBM
                    self.🚩amount50g = ⓒontext.amount50g
                } else {
                    assertionFailure()
                }
            } else {
                assertionFailure()
            }
        }
    }
}

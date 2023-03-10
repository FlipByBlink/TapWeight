import SwiftUI
import WatchConnectivity

class 🅂yncDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleLBM") var 🚩ableLBM: Bool = false
    
    //MARK: Required(watchOS, iOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Nothing to do.
    }
}

extension 🅂yncDelegate: WKApplicationDelegate {
    func applicationDidBecomeActive() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension 🅂yncDelegate {
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("🖨️", #function, applicationContext.description)
        Task { @MainActor in
            if let ⓥalue = applicationContext["Amount50g"] as? Bool {
                self.🚩amount50g = ⓥalue
            }
            if let ⓥalue = applicationContext["AbleBMI"] as? Bool {
                self.🚩ableBMI = ⓥalue
            }
            if let ⓥalue = applicationContext["AbleBodyFat"] as? Bool {
                self.🚩ableBodyFat = ⓥalue
            }
            if let ⓥalue = applicationContext["AbleLBM"] as? Bool {
                self.🚩ableLBM = ⓥalue
            }
        }
    }
}

import SwiftUI
import WatchConnectivity

class 🅂yncDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleLBM") var 🚩ableLBM: Bool = false
    
    //MARK: Required(watchOS, iOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(#function, ": Nothing to do.")
    }
    
    func ⓢync() {
        do {
            try WCSession.default.updateApplicationContext(["Amount50g": self.🚩amount50g,
                                                            "AbleBMI": self.🚩ableBMI,
                                                            "AbleBodyFat": self.🚩ableBodyFat,
                                                            "AbleLBM": self.🚩ableLBM,])
        } catch {
            print("🚨", error.localizedDescription)
        }
    }
}

#if os(iOS)
extension 🅂yncDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        return true
    }
}

extension 🅂yncDelegate {
    //MARK: Required
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue). Nothing to do.")
    }
    
    //MARK: Required
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
#endif

#if os(watchOS)
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
#endif

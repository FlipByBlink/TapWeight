import WatchConnectivity
import HealthKit

struct 🄲ontext: Codable, Equatable {
    var amount50g: Bool
    var ableBMI: Bool
    var ableBodyFat: Bool
    var ableLBM: Bool
    
    func send() {
        do {
            let ⓓictionary = ["ⓒontext": try JSONEncoder().encode(self)]
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(ⓓictionary, replyHandler: nil)
            } else {
                try WCSession.default.updateApplicationContext(ⓓictionary)
            }
        } catch {
            print("🚨", #function, error.localizedDescription)
        }
    }
    
    static func receive(_ ⓓictionary: [String : Any]) -> Self? {
        if let ⓓata = ⓓictionary["ⓒontext"] as? Data {
            do {
                return try JSONDecoder().decode(Self.self, from: ⓓata)
                
            } catch {
                print("🚨", #function, error.localizedDescription)
            }
        }
        return nil
    }
}

import WatchConnectivity
import HealthKit

struct 🄲ontext: Codable, Equatable {
    var amount50g: Bool
    var ableBMI: Bool
    var ableBodyFat: Bool
    var ableLBM: Bool
    
    func sync() {
        do {
            try WCSession.default.updateApplicationContext(["ⓒontext": try JSONEncoder().encode(self)])
        } catch {
            print("🚨", error.localizedDescription)
        }
    }
    
    static func receive(_ ⓓata: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: ⓓata)
        } catch {
            print("🚨", error.localizedDescription)
            return nil
        }
    }
}

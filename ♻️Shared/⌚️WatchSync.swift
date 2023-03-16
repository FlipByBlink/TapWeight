//import WatchConnectivity
import HealthKit

struct 🄲ontext: Codable, Equatable {
    var amount50g: Bool
    var ableBMI: Bool
    var ableBodyFat: Bool
    var ableLBM: Bool
    var massKilogramValue: Double?
    var heightMeterValue: Double?
    var bodyFatCountValue: Double?
    
    var asData: Data { try! JSONEncoder().encode(self) }
    
    func save() {
        NSUbiquitousKeyValueStore.default.set(self.asData, forKey: "ⓒontext")
    }
    
    static func load() -> Self? {
        if let ⓞbject = NSUbiquitousKeyValueStore.default.object(forKey: "ⓒontext") {
            if let ⓓata = ⓞbject as? Data {
                return try? JSONDecoder().decode(Self.self, from: ⓓata)
            }
        }
        return nil
    }
    
    var massQuantity: HKQuantity? {
        guard let ⓜassKilogramValue = self.massKilogramValue else { return nil }
        return HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: ⓜassKilogramValue)
    }
    var heightSample: HKQuantitySample? {
        guard let ⓗeightMetarValue = self.heightMeterValue else { return nil }
        return HKQuantitySample(type: HKQuantityType(.height),
                                quantity: HKQuantity(unit: .meter(), doubleValue: ⓗeightMetarValue),
                                start: .now, end: .now)
    }
    var bodyFatQuantity: HKQuantity? {
        guard let ⓑodyFatCountValue = self.bodyFatCountValue else { return nil }
        return HKQuantity(unit: .count(), doubleValue: ⓑodyFatCountValue)
    }
    
    //func send() {
    //    do {
    //        let ⓓictionary = ["ⓒontext": try JSONEncoder().encode(self)]
    //        if WCSession.default.isReachable {
    //            WCSession.default.sendMessage(ⓓictionary, replyHandler: nil)
    //        } else {
    //            try WCSession.default.updateApplicationContext(ⓓictionary)
    //        }
    //    } catch {
    //        print("🚨", #function, error.localizedDescription)
    //    }
    //}
    //
    //static func receive(_ ⓓictionary: [String : Any]) -> Self? {
    //    if let ⓓata = ⓓictionary["ⓒontext"] as? Data {
    //        do {
    //            return try JSONDecoder().decode(Self.self, from: ⓓata)
    //
    //        } catch {
    //            print("🚨", #function, error.localizedDescription)
    //        }
    //    }
    //    return nil
    //}
}

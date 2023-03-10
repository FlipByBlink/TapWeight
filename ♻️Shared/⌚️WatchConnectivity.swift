import WatchConnectivity
import HealthKit

struct 🄲ontext: Codable, Equatable {
    var amount50g: Bool
    var ableBMI: Bool
    var ableBodyFat: Bool
    var ableLBM: Bool
    
    var massKilogramValue: Double?
    var heightMeterValue: Double?
    var bodyFatValue: Double?
    
//    var massQuantity: HKQuantity? {
//        guard let ⓥalue = self.massKilogramValue else { return nil }
//        return HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: ⓥalue)
//    }
//    
//    var heightSample: HKQuantitySample? {
//        guard let ⓥalue = self.heightMeterValue else { return nil }
//        return HKQuantitySample(type: .init(.height),
//                                quantity: HKQuantity(unit: .meter(), doubleValue: ⓥalue),
//                                start: .now, end: .now)
//    }
//    
//    var bodyFatQuantity: HKQuantity? {
//        guard let ⓥalue = self.bodyFatValue else { return nil }
//        return HKQuantity(unit: .count(), doubleValue: ⓥalue)
//    }
    
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

//import WatchConnectivity
import HealthKit

struct 🄲ontext: Codable, Equatable {
    var amount50g: Bool
    var ableBMI: Bool
    var ableBodyFat: Bool
    var ableLBM: Bool
    var latestSamples: [🏥Category: 🅂ample] = [:]
    
    struct 🅂ample: Codable, Equatable {
        var category: 🏥Category
        var doubleValue: Double
        var date: Date
        var asHKQuantitySample: HKQuantitySample {
            HKQuantitySample(type: self.category.quantityType,
                             quantity: HKQuantity(unit: self.category.defaultUnit,
                                                  doubleValue: self.doubleValue),
                             start: self.date, end: self.date)
        }
    }
    
    init(_ ⓐmount50g: Bool, _ ⓐbleBMI: Bool, _ ⓐbleBodyFat: Bool, _ ⓐbleLBM: Bool, _ ⓛatestSamples: [🏥Category: HKQuantitySample]) {
        self.amount50g = ⓐmount50g
        self.ableBMI = ⓐbleBMI
        self.ableBodyFat = ⓐbleBodyFat
        self.ableLBM = ⓐbleLBM
        ⓛatestSamples.forEach { (ⓚey, ⓥalue) in
            self.latestSamples[ⓚey] = 🅂ample(category: ⓚey,
                                              doubleValue: ⓥalue.quantity.doubleValue(for: ⓚey.defaultUnit),
                                              date: ⓥalue.startDate)
        }
    }
    
    var latestHKQuantitySamples: [🏥Category: HKQuantitySample] {
        self.latestSamples.mapValues { $0.asHKQuantitySample }
    }
    
    func set() {
        NSUbiquitousKeyValueStore.default.set(try! JSONEncoder().encode(self),
                                              forKey: "ⓒontext")
    }
    
#if os(watchOS)
    static var iCloudKVS: Self? {
        guard let ⓞbject = NSUbiquitousKeyValueStore.default.object(forKey: "ⓒontext") else { return nil }
        guard let ⓓata = ⓞbject as? Data else { return nil }
        return try? JSONDecoder().decode(Self.self, from: ⓓata)
    }
#endif
    
    var invalidSampleCategories: [🏥Category] {
        var ⓥalue: [🏥Category] = []
        if self.latestSamples[.bodyMass] == nil {
            ⓥalue += [.bodyMass]
        }
        if self.ableBMI && (self.latestSamples[.height] == nil) {
            ⓥalue += [.height]
        }
        if self.ableBodyFat && (self.latestSamples[.bodyFatPercentage] == nil) {
            ⓥalue += [.bodyFatPercentage]
        }
        return ⓥalue
    }
    
    var isValid: Bool {
        self.invalidSampleCategories.isEmpty
    }
    
    //func sendMessage() {
    //    do {
    //        if WCSession.default.isReachable {
    //            WCSession.default.sendMessage(["ⓒontext": try JSONEncoder().encode(self)],
    //                                          replyHandler: nil)
    //        }
    //    } catch {
    //        print("🚨", #function, error.localizedDescription)
    //    }
    //}
    //
    //static func decode(_ ⓓictionary: [String : Any]) -> Self? {
    //    if let ⓓata = ⓓictionary["ⓒontext"] as? Data {
    //        do {
    //            return try JSONDecoder().decode(Self.self, from: ⓓata)
    //        } catch {
    //            print("🚨", #function, error.localizedDescription)
    //        }
    //    }
    //    return nil
    //}
}

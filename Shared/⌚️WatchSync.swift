import HealthKit
import WatchConnectivity

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
    
#if os(iOS)
    func sendToWatchApp() {
        self.updateWCContext()
        self.setICloudKVS()
    }
    private func setICloudKVS() {
        NSUbiquitousKeyValueStore.default.set(try! JSONEncoder().encode(self),
                                              forKey: "ⓒontext")
    }
    private func updateWCContext() {
        do {
            if WCSession.default.activationState == .activated {
                if WCSession.default.isWatchAppInstalled {
                    try WCSession.default.updateApplicationContext(["ⓒontext": try JSONEncoder().encode(self)])
                }
            }
        } catch {
            print("🚨", #function, error.localizedDescription)
        }
    }
#elseif os(watchOS)
    static var iCloudKVS: Self? {
        guard let ⓞbject = NSUbiquitousKeyValueStore.default.object(forKey: "ⓒontext") else { return nil }
        guard let ⓓata = ⓞbject as? Data else { return nil }
        return try? JSONDecoder().decode(Self.self, from: ⓓata)
    }
    static var wcApplicationContext: Self? {
        Self.decode(WCSession.default.applicationContext)
    }
    static func decode(_ ⓓictionary: [String : Any]) -> Self? {
        if let ⓓata = ⓓictionary["ⓒontext"] as? Data {
            do {
                return try JSONDecoder().decode(Self.self, from: ⓓata)
            } catch {
                print("🚨", #function, error.localizedDescription)
            }
        }
        return nil
    }
#endif
}

import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    
    @Published var 📝massInputQuantity: HKQuantity? = nil
    var ⓜassUnit: HKUnit? { self.📦units[.bodyMass] }
    var ⓜassInputValue: Double? {
        guard let ⓜassUnit else { return nil }
        return self.📝massInputQuantity?.doubleValue(for: ⓜassUnit)
    }
    var ⓜassInputDescription: String {
        if let ⓜassInputValue {
            if self.🚩amount50g {
                return String(format: "%.2f", ⓜassInputValue)
            } else {
                return ⓜassInputValue.description
            }
        } else {
            return self.🚩amount50g ? "00.00" : "00.0"
        }
    }
    
    var 📝bmiInputValue: Double? {
        guard let 📝massInputQuantity else { return nil }
        let ⓚiloMassValue = 📝massInputQuantity.doubleValue(for: .gramUnit(with: .kilo))
        guard let ⓗeightSample = self.📦latestSamples[.height] else { return nil }
        let ⓗeightValue = ⓗeightSample.quantity.doubleValue(for: .meter())
        let ⓥalue = ⓚiloMassValue / pow(ⓗeightValue, 2)
        return Double(Int(round(ⓥalue * 10))) / 10
    }
    var ⓗeightUnit: HKUnit? { self.📦units[.height] }
    var ⓗeightValue: Double? {
        guard let ⓗeightUnit else { return nil }
        return self.📦latestSamples[.height]?.quantity.doubleValue(for: ⓗeightUnit)
    }
    
    @Published var 📝bodyFatInputQuantity: HKQuantity? = nil
    var ⓑodyFatInputValue: Double? {
        return self.📝bodyFatInputQuantity?.doubleValue(for: .percent())
    }
    var ⓑodyFatInputDescription: String {
        if let ⓑodyFatInputValue {
            return (round(ⓑodyFatInputValue * 1000) / 10).description
        } else {
            return "00.0"
        }
    }

    @Published var 📅pickerValue: Date = .now
    var 🚩datePickerIsAlmostNow: Bool { self.📅pickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚨registerError: Bool = false
    @Published var 🚩canceled: Bool = false
    @Published var 🚨cancelError: Bool = false
    
    private let 🏥healthStore = HKHealthStore()
    @Published var 📦latestSamples: [HKQuantityTypeIdentifier: HKQuantitySample] = [:]
    @Published var 📦units: [HKQuantityTypeIdentifier: HKUnit] = [:]
    
    var 📨registeredSamples: [HKQuantitySample] = []
    
    @MainActor
    func 👆register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        guard self.🏥sharingAuthorized() else { return }
        var ⓢamples: [HKQuantitySample] = []
        let ⓓate: Date = self.🚩ableDatePicker ? self.📅pickerValue : .now
        if let 📝massInputQuantity {
            ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                            quantity: 📝massInputQuantity,
                                            start: ⓓate, end: ⓓate))
        }
        if self.🚩ableBMI {
            if let 📝bmiInputValue {
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                                quantity: HKQuantity(unit: .count(),
                                                                     doubleValue: 📝bmiInputValue),
                                                start: ⓓate, end: ⓓate))
            }
        }
        if self.🚩ableBodyFat {
            if let 📝bodyFatInputQuantity {
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                quantity: 📝bodyFatInputQuantity,
                                                start: ⓓate, end: ⓓate))
            }
        }
        do {
            try await self.🏥healthStore.save(ⓢamples)
            self.📨registeredSamples = ⓢamples
        } catch {
            self.🚨registerError = true
            print("🚨", error.localizedDescription)
        }
    }
    
    private func 🏥sharingAuthorized() -> Bool {
        var ⓣypes: [HKQuantityTypeIdentifier] = [.bodyMass]
        if self.🚩ableBMI { ⓣypes.append(.bodyMassIndex) }
        if self.🚩ableBodyFat { ⓣypes.append(.bodyFatPercentage) }
        for ⓣype in ⓣypes {
            if self.🏥healthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingAuthorized {
                continue
            } else {
                self.🚨registerError = true
                return false
            }
        }
        return true
    }
    
    func 🏥requestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        let ⓢhareType: Set<HKQuantityType> = [HKQuantityType(ⓘdentifier)]
        var ⓡeadTypes: Set<HKQuantityType> {
            if ⓘdentifier == .bodyMassIndex {
                return [HKQuantityType(.bodyMassIndex), HKQuantityType(.height)]
            } else {
                return [HKQuantityType(ⓘdentifier)]
            }
        }
        Task {
            do {
                let ⓢtatus = try await self.🏥healthStore.statusForAuthorizationRequest(toShare: ⓢhareType, read: ⓡeadTypes)
                if ⓢtatus == .shouldRequest {
                    try await self.🏥healthStore.requestAuthorization(toShare: ⓢhareType, read: ⓡeadTypes)
                    self.🏥loadLatestSamples()
                    await self.🏥loadUnits()
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    
    func ⓢetupOnLaunch() {
        self.🏥requestAuth(.bodyMass)
        self.🔭observeChanges()
    }
    
    func 🏥loadLatestSamples() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass]
        for ⓘdentifier in ⓘdentifiers {
            let ⓢortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let ⓠuery = HKSampleQuery(sampleType: HKQuantityType(ⓘdentifier),
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [ⓢortDescriptors]) { _, ⓢamples, _ in
                Task { @MainActor in
                    if let ⓢamples {
                        self.📦latestSamples[ⓘdentifier] = ⓢamples.first as? HKQuantitySample
                        self.📝resetPickerValues()
                    }
                    if ⓢamples == [] {
                        switch ⓘdentifier {
                            case .bodyMass:
                                if let ⓤnit = self.📦units[.bodyMass] {
                                    switch ⓤnit {
                                        case .gramUnit(with: .kilo):
                                            self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 60.0)
                                        case .pound():
                                            self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 130.0)
                                        case .stone():
                                            self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 10.0)
                                        default:
                                            break
                                    }
                                }
                            case .bodyFatPercentage:
                                self.📝bodyFatInputQuantity = HKQuantity(unit: .percent(), doubleValue: 0.2)
                            default:
                                break
                        }
                    }
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    func 📝resetPickerValues() {
        if let ⓢample = self.📦latestSamples[.bodyMass] {
            self.📝massInputQuantity = ⓢample.quantity
        }
        if let ⓢample = self.📦latestSamples[.bodyFatPercentage] {
            self.📝bodyFatInputQuantity = ⓢample.quantity
        }
    }
    
    @MainActor
    private func 🏥loadUnits() async {
        for ⓘdentifier: HKQuantityTypeIdentifier in [.bodyMass, .height, .leanBodyMass] {
            if let ⓤnit = try? await self.🏥healthStore.preferredUnits(for: [HKQuantityType(ⓘdentifier)]).first?.value {
                if self.📦units[ⓘdentifier] != ⓤnit {
                    self.📦units[ⓘdentifier] = ⓤnit
                    self.📝resetPickerValues()
                }
            }
        }
    }
    
    private func 🔭observeChanges() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass]
        for ⓘdentifier in ⓘdentifiers {
            let ⓣype = HKQuantityType(ⓘdentifier)
            let ⓠuery = HKObserverQuery(sampleType: ⓣype, predicate: nil) { _, ⓒompletionHandler, ⓔrror in
                if ⓔrror != nil { return }
                Task {
                    self.🏥loadLatestSamples()
                    await self.🏥loadUnits()
                    ⓒompletionHandler()
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    enum 🅂tepPattern {
        case increment, decrement
    }
    
    func stepMassValue(_ ⓟattern: 🅂tepPattern) {
        if let ⓜassUnit, var ⓜassInputValue {
            if self.🚩amount50g {
                switch ⓟattern {
                    case .increment: ⓜassInputValue += 0.05
                    case .decrement: ⓜassInputValue -= 0.05
                }
                ⓜassInputValue = round(ⓜassInputValue * 100) / 100
            } else {
                switch ⓟattern {
                    case .increment: ⓜassInputValue += 0.1
                    case .decrement: ⓜassInputValue -= 0.1
                }
                ⓜassInputValue = round(ⓜassInputValue * 10) / 10
            }
            self.📝massInputQuantity = HKQuantity(unit: ⓜassUnit, doubleValue: ⓜassInputValue)
        }
    }
    
    func stepBodyFatValue(_ ⓟattern: 🅂tepPattern) {
        if var ⓑodyFatInputValue {
            switch ⓟattern {
                case .increment: ⓑodyFatInputValue += 0.001
                case .decrement: ⓑodyFatInputValue -= 0.001
            }
            ⓑodyFatInputValue = round(ⓑodyFatInputValue * 1000) / 1000
            self.📝bodyFatInputQuantity = HKQuantity(unit: .percent(), doubleValue: ⓑodyFatInputValue)
        }
    }
    
    var differenceDescriptions: [HKQuantityTypeIdentifier: String] {
        var ⓓescriptions: [HKQuantityTypeIdentifier: String] = [:]
        for ⓣype: HKQuantityTypeIdentifier in [.bodyMass, .bodyMassIndex, .bodyFatPercentage, .leanBodyMass] {
            let ⓛastSample = self.📦latestSamples[ⓣype]
            var 📉difference: Double? = nil
            if let 📝lastValue = ⓛastSample?.quantity {
                switch ⓣype {
                    case .bodyMass:
                        if let ⓤnit = self.📦units[ⓣype] {
                            if let ⓜassInputValue {
                                📉difference = round((ⓜassInputValue - 📝lastValue.doubleValue(for: ⓤnit)) * 100) / 100
                            }
                        }
                    case .bodyMassIndex:
                        if let 📝bmiInputValue {
                            📉difference = round((📝bmiInputValue - 📝lastValue.doubleValue(for: .count())) * 10) / 10
                        } else {
                            continue
                        }
                    case .bodyFatPercentage:
                        if let ⓑodyFatInputValue {
                            📉difference = round((ⓑodyFatInputValue - 📝lastValue.doubleValue(for: .percent())) * 1000) / 10
                        }
                    default:
                        continue
                }
                if let 📉difference {
                    switch 📉difference {
                        case ..<0:
                            if ⓣype == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = String(format: "%.2f", 📉difference)
                            } else {
                                ⓓescriptions[ⓣype] = 📉difference.description
                            }
                        case 0:
                            if ⓣype == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = "0.00"
                            } else {
                                ⓓescriptions[ⓣype] = "0.0"
                            }
                        default:
                            if ⓣype == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = "+" + String(format: "%.2f", 📉difference)
                            } else {
                                ⓓescriptions[ⓣype] = "+" + 📉difference.description
                            }
                    }
                }
            }
        }
        return ⓓescriptions
    }
    
    @MainActor
    func 🗑cancel() {
        Task {
            do {
                self.🚩canceled = true
                try await self.🏥healthStore.delete(self.📨registeredSamples)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } catch {
                self.🚨cancelError = true
                print("🚨", error.localizedDescription)
            }
        }
    }
    
    func ⓡeset() {
        self.🚨registerError = false
        self.🚩canceled = false
        self.🚨cancelError = false
        self.📨registeredSamples = []
    }
}


//func 🏥getLatestValue() {
//    let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .bodyFatPercentage]
//    for ⓘdentifier in ⓘdentifiers {
//        let ⓠuery = HKSampleQuery(sampleType: HKQuantityType(ⓘdentifier),
//                                  predicate: nil,
//                                  limit: 1,
//                                  sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, ⓢamples, _ in
//            Task { @MainActor in
//                if let ⓢample = ⓢamples?.first as? HKQuantitySample {
//                    switch ⓘdentifier {
//                        case .bodyMass:
//                            let ⓥalue = ⓢample.quantity.doubleValue(for: self.📏massUnit.hkunit)
//                            if self.🚩amount50g {
//                                self.📝massValue = round(ⓥalue * 20) / 20
//                            } else {
//                                self.📝massValue = round(ⓥalue * 10) / 10
//                            }
//                            self.💾lastSamples[.bodyMass] = ⓢample
//                        case .bodyMassIndex:
//                            self.💾lastSamples[.bodyMassIndex] = ⓢample
//                        case .bodyFatPercentage:
//                            self.📝bodyFatValue = ⓢample.quantity.doubleValue(for: .percent())
//                            self.💾lastSamples[.bodyFatPercentage] = ⓢample
//                        default:
//                            print("🐛")
//                    }
//                }
//            }
//        }
//        self.🏥healthStore.execute(ⓠuery)
//    }
//}


//@MainActor
//private func 🏥getPreferredMassUnit() async throws {
//    if let 📏 = try await self.🏥healthStore.preferredUnits(for: [HKQuantityType(.bodyMass)]).first {
//        switch 📏.value {
//            case .gramUnit(with: .kilo):
//                self.📏massUnit = .kg
//                self.📝massValue = 60
//            case .pound():
//                self.📏massUnit = .lbs
//                self.📝massValue = 130
//            case .stone():
//                self.📏massUnit = .st
//                self.📝massValue = 10
//            default:
//                print("🐛")
//        }
//    }
//}

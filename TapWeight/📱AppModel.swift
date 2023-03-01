import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    
    @Published var 📝massInputValue: Double? = nil
    var 📝bmiInputValue: Double? {
        guard let ⓜassUnit = self.📦units[.bodyMass] else { return nil }
        guard let 📝massInputValue else { return nil }
        let ⓠuantity = HKQuantity(unit: ⓜassUnit, doubleValue: 📝massInputValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        guard let ⓗeightSample = self.📦latestSamples[.height] else { return nil }
        let ⓗeightValue = ⓗeightSample.quantity.doubleValue(for: .meterUnit(with: .centi))
        let ⓥalue = ⓚiloMassValue / pow((Double(ⓗeightValue) / 100), 2)
        return Double(Int(round(ⓥalue * 10))) / 10
    }
    @Published var 📝bodyFatInputValue: Double? = nil
    
    @Published var 📅pickerValue: Date = .now
    var 🚩datePickerIsAlmostNow: Bool { self.📅pickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚨registerError: Bool = false
    @Published var 🚩canceled: Bool = false
    @Published var 🚨cancelError: Bool = false
    
    private let 🏥healthStore = HKHealthStore()
    @Published var 📦latestSamples: [HKQuantityTypeIdentifier: HKQuantitySample] = [:]
    @Published var 📦units: [HKQuantityTypeIdentifier: HKUnit] = [:]
    
    var 📨cacheSamples: [HKQuantitySample] = []
    
    @MainActor
    func 👆register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        guard self.🏥sharingAuthorized() else { return }
        var ⓢamples: [HKQuantitySample] = []
        let ⓓate: Date = self.🚩ableDatePicker ? self.📅pickerValue : .now
        if let ⓤnit = self.📦units[.bodyMass] {
            if let 📝massInputValue {
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                                quantity: HKQuantity(unit: ⓤnit, doubleValue: 📝massInputValue),
                                                start: ⓓate, end: ⓓate))
            }
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
            if let 📝bodyFatInputValue {
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                quantity: HKQuantity(unit: .percent(),
                                                                     doubleValue: 📝bodyFatInputValue),
                                                start: ⓓate, end: ⓓate))
            }
        }
        do {
            try await self.🏥healthStore.save(ⓢamples)
            self.📨cacheSamples = ⓢamples
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
    
    private func 🏥checkShouldRequestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let ⓣype = HKQuantityType(ⓘdentifier)
        return try await self.🏥healthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest
    }
    
    func 🏥requestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        Task {
            do {
                if try await self.🏥checkShouldRequestAuth(ⓘdentifier) {
                    let ⓣype = HKQuantityType(ⓘdentifier)
                    try await self.🏥healthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    self.🏥loadLatestSamples()
                    await self.🏥loadUnits()
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    
    func 🏥checkAuthOnLaunch() {
        Task {
            do {
                var ⓣypes: Set<HKSampleType> = []
                if try await self.🏥checkShouldRequestAuth(.bodyMass) {
                    ⓣypes.insert(HKQuantityType(.bodyMass))
                }
                if self.🚩ableBMI {
                    if try await self.🏥checkShouldRequestAuth(.bodyMassIndex) {
                        ⓣypes.insert(HKQuantityType(.bodyMassIndex))
                    }
                }
                if self.🚩ableBodyFat {
                    if try await self.🏥checkShouldRequestAuth(.bodyFatPercentage) {
                        ⓣypes.insert(HKQuantityType(.bodyFatPercentage))
                    }
                }
                if !ⓣypes.isEmpty {
                    if try await self.🏥healthStore.statusForAuthorizationRequest(toShare: ⓣypes, read: ⓣypes) == .shouldRequest {
                        try await self.🏥healthStore.requestAuthorization(toShare: ⓣypes, read: ⓣypes)
                        if ⓣypes.contains(HKQuantityType(.bodyMass)) { await self.🏥loadUnits() }
                        self.🏥loadLatestSamples()
                    }
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    
    func 🏥loadLatestSamples() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass]
        for ⓘdentifier in ⓘdentifiers {
            let ⓢortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let ⓠuery = HKSampleQuery(sampleType: HKQuantityType(ⓘdentifier),
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [ⓢortDescriptors]) { _, ⓢamples, _ in
                if let ⓢamples {
                    Task { @MainActor in
                        self.📦latestSamples[ⓘdentifier] = ⓢamples.first as? HKQuantitySample
                        self.📝resetPickerValues()
                        if ⓢamples.isEmpty {
                            switch ⓘdentifier {
                                case .bodyMass:
                                    if let ⓤnit = self.📦units[.bodyMass] {
                                        switch ⓤnit {
                                            case .gramUnit(with: .kilo): self.📝massInputValue = 60.0
                                            case .pound(): self.📝massInputValue = 130
                                            case .stone(): self.📝massInputValue = 10
                                            default: break
                                        }
                                    }
                                case .bodyFatPercentage:
                                    self.📝bodyFatInputValue = 0.2
                                default:
                                    break
                            }
                        }
                    }
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    func 📝resetPickerValues() {
        if let ⓜassUnit = self.📦units[.bodyMass] {
            self.📝massInputValue = self.📦latestSamples[.bodyMass]?.quantity.doubleValue(for: ⓜassUnit)
        }
        self.📝bodyFatInputValue = self.📦latestSamples[.bodyFatPercentage]?.quantity.doubleValue(for: .percent())
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
    
    func 🔭observeChanges() {
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
    
    func incrementMassStepper() {
        if var 📝massInputValue {
            if self.🚩amount50g {
                📝massInputValue += 0.05
                self.📝massInputValue = round(📝massInputValue * 100) / 100
            } else {
                📝massInputValue += 0.1
                self.📝massInputValue = round(📝massInputValue * 10) / 10
            }
        }
    }
    
    func decrementMassStepper() {
        if var 📝massInputValue {
            if self.🚩amount50g {
                📝massInputValue -= 0.05
                self.📝massInputValue = round(📝massInputValue * 100) / 100
            } else {
                📝massInputValue -= 0.1
                self.📝massInputValue = round(📝massInputValue * 10) / 10
            }
        }
    }
    
    func incrementBodyFatStepper() {
        if var 📝bodyFatInputValue {
            📝bodyFatInputValue += 0.001
            self.📝bodyFatInputValue = round(📝bodyFatInputValue * 1000) / 1000
        }
    }
    
    func decrementBodyFatStepper() {
        if var 📝bodyFatInputValue {
            📝bodyFatInputValue -= 0.001
            self.📝bodyFatInputValue = round(📝bodyFatInputValue * 1000) / 1000
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
                            if let 📝massInputValue {
                                📉difference = round((📝massInputValue - 📝lastValue.doubleValue(for: ⓤnit)) * 100) / 100
                            }
                        }
                    case .bodyMassIndex:
                        if let 📝bmiInputValue {
                            📉difference = round((📝bmiInputValue - 📝lastValue.doubleValue(for: .count())) * 10) / 10
                        } else {
                            continue
                        }
                    case .bodyFatPercentage:
                        if let 📝bodyFatInputValue {
                            📉difference = round((📝bodyFatInputValue - 📝lastValue.doubleValue(for: .percent())) * 1000) / 10
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
                try await self.🏥healthStore.delete(self.📨cacheSamples)
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
        self.📨cacheSamples = []
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

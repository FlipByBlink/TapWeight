import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    
    @Published var 📝massValue: Double = 65.0
    var 📝bmiValue: Double? {
        guard let ⓜassUnit = self.📦units[.bodyMass] else { return nil }
        let ⓠuantity = HKQuantity(unit: ⓜassUnit, doubleValue: self.📝massValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        guard let ⓗeightValue = self.📦latestSamples[.height]?.quantity.doubleValue(for: .meterUnit(with: .centi)) else { return nil }
        let ⓥalue = ⓚiloMassValue / pow((Double(ⓗeightValue) / 100), 2)
        return Double(Int(round(ⓥalue * 10))) / 10
    }
    @Published var 📝bodyFatValue: Double = 0.2
    
    @Published var 📅pickerValue: Date = .now
    var 🚩datePickerIsAlmostNow: Bool { self.📅pickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚨registerError: Bool = false
    @Published var 🚩canceled: Bool = false
    @Published var 🚨cancelError: Bool = false
    
    private let 🏥healthStore = HKHealthStore()
    @Published var 📦latestSamples: [HKQuantityTypeIdentifier: HKQuantitySample] = [:]
    @Published var 📦units: [HKQuantityTypeIdentifier: HKUnit] = [:]
    
    var 📨registeringSamples: [HKQuantitySample] = []
    
    @MainActor
    func 👆register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if self.🏥checkAuthDenied(.bodyMass) { return }
        if self.🚩ableBMI {
            if self.🏥checkAuthDenied(.bodyMassIndex) { return }
        }
        if self.🚩ableBodyFat {
            if self.🏥checkAuthDenied(.bodyFatPercentage) { return }
        }
        let ⓓate: Date = self.🚩ableDatePicker ? self.📅pickerValue : .now
        if let ⓤnit = self.📦units[.bodyMass] {
            self.📨registeringSamples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                            quantity: HKQuantity(unit: ⓤnit,
                                                                 doubleValue: self.📝massValue),
                                            start: ⓓate, end: ⓓate))
        }
        if self.🚩ableBMI {
            if let 📝bmiValue {
                self.📨registeringSamples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                                quantity: HKQuantity(unit: .count(),
                                                                     doubleValue: 📝bmiValue),
                                                start: ⓓate, end: ⓓate))
            }
        }
        if self.🚩ableBodyFat {
            self.📨registeringSamples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                   quantity: HKQuantity(unit: .percent(),
                                                                        doubleValue: self.📝bodyFatValue),
                                                   start: ⓓate, end: ⓓate))
        }
        do {
            try await self.🏥healthStore.save(self.📨registeringSamples)
        } catch {
            self.🚨registerError = true
            print("🚨", error.localizedDescription)
        }
    }
    
    private func 🏥checkAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if self.🏥healthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            self.🚨registerError = true
            return true
        } else {
            return false
        }
    }
    
    private func 🏥checkShouldRequestAuth(_ identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let ⓣype = HKQuantityType(identifier)
        return try await self.🏥healthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest
    }
    
    func 🏥requestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        Task {
            do {
                if try await self.🏥checkShouldRequestAuth(ⓘdentifier) {
                    let ⓣype = HKQuantityType(ⓘdentifier)
                    try await self.🏥healthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    self.loadLatestSamples()
                    await self.loadUnitsAndSetLatestValue()
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
                        if ⓣypes.contains(HKQuantityType(.bodyMass)) { await self.loadUnitsAndSetLatestValue() }
                        self.loadLatestSamples()
                    }
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    
    func loadLatestSamples() {
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
                    }
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    private func loadUnitsAndSetLatestValue() async {
        for ⓘdentifier: HKQuantityTypeIdentifier in [.bodyMass, .height, .leanBodyMass] {
            if let ⓤnit = try? await self.🏥healthStore.preferredUnits(for: [HKQuantityType(ⓘdentifier)]).first?.value {
                self.📦units[ⓘdentifier] = ⓤnit
                switch ⓘdentifier {
                    case .bodyMass:
                        if let ⓥalue = self.📦latestSamples[.bodyMass]?.quantity.doubleValue(for: ⓤnit) {
                            self.📝massValue = ⓥalue
                        } else {
                            switch ⓤnit {
                                case .gramUnit(with: .kilo):
                                    self.📝massValue = 60.0
                                case .pound():
                                    self.📝massValue = 130
                                case .stone():
                                    self.📝massValue = 10
                                default:
                                    break
                            }
                        }
                    case .bodyFatPercentage:
                        self.📝bodyFatValue = self.📦latestSamples[.bodyFatPercentage]?.quantity.doubleValue(for: .percent()) ?? 20
                    default:
                        break
                }
            }
        }
    }
    
    func observeChanges() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass]
        for ⓘdentifier in ⓘdentifiers {
            let ⓣype = HKQuantityType(ⓘdentifier)
            let ⓠuery = HKObserverQuery(sampleType: ⓣype, predicate: nil) { _, ⓒompletionHandler, ⓔrror in
                if ⓔrror != nil { return }
                Task {
                    self.loadLatestSamples()
                    await self.loadUnitsAndSetLatestValue()
                    ⓒompletionHandler()
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    func 🗑cancel() {
        Task {
            do {
                self.🚩canceled = true
                try await self.🏥healthStore.delete(self.📨registeringSamples)
                self.loadLatestSamples()
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
        self.📨registeringSamples = []
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
